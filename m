Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2CJXiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:38:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34486 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753382Ab2CJXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:38:50 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/T+XdGh6vTkZZnuHRNFEmdz7obo91IdE7T0EJfoy
	K2gdhk5FTrfIpL
Message-ID: <4F5BE563.9050506@gmx.de>
Date: Sun, 11 Mar 2012 00:36:03 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>, WANG Cong <amwang@redhat.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frank Danapfel <fdanapfe@redhat.com>, Laszlo Ersek <lersek@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: [PATCH] enhance usability of /proc/sys/net/ipv4/ip_local_reserved_ports
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to the ip_local_reserved_ports proc file it will currently clear
all previously reserved ports and update the current list with the one given 
in the input.

This behaviour makes it's usage quite hard, for example:
a) The generic proc filesystem limitation of only handle up to PAGE_SIZE-1
   characters at maximum may not be sufficient to provide all your wished-to-
   be-reserved ports at once.
b) There is no easy way to disable specific given ports, you always need to
   give the full port list at once. This makes shell scripting hard, since
   you need to parse everything yourself.
c) There is no easy way to just add specific ports or port ranges. Again,
   this would be useful for shell scripts.

The following patch solves this problem by simply extending the parser
in proc_do_large_bitmap() to accept the keywords "add" and "release" in front
of given ports or port ranges and to either add or drop the given ports
from the already existing list.

Here is an example:
$ echo "1000-2000,5000" > /proc/sys/net/ipv4/ip_local_reserved_ports
$ cat /proc/sys/net/ipv4/ip_local_reserved_ports
1000-2000,5000   (works as before, current port list is replaced by new one)

$ echo "add 3000-4000" > /proc/sys/net/ipv4/ip_local_reserved_ports
$ cat /proc/sys/net/ipv4/ip_local_reserved_ports
1000-2000,3000-4000,5000   (new ports added)

$ echo "release 1500-3500" > /proc/sys/net/ipv4/ip_local_reserved_ports
$ cat /proc/sys/net/ipv4/ip_local_reserved_ports
1000-1499,3501-4000,5000   (given ports were dropped from the list)

My main motivation for this patch is a huge commercial application which
by default may use lots of ports. The full port list which I would have needed
to echo to the /proc/sys/net/ipv4/ip_local_reserved_ports file was around
30K, and in this case all ports were already combined to regions where possible.
With this patch it's now easy to split up the port ranges into single pieces
and to implement everything in simple bootup shell scripts. Furthermore
adding new or removing unneeded ports dynamically at runtime is now easily
possible.


Signed-off-by: Helge Deller <deller@gmx.de>


 Documentation/networking/ip-sysctl.txt |   10 ++++++
 kernel/sysctl.c                        |   48 +++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 9 deletions(-)



diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ad3e80e..2ca93ab 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -624,7 +624,15 @@ ip_local_reserved_ports - list of comma separated ranges
 	list of ranges (e.g. "1,2-4,10-10" for ports 1, 2, 3, 4 and
 	10). Writing to the file will clear all previously reserved
 	ports and update the current list with the one given in the
-	input.
+	input. When writing to the file the keywords "add" or "release"
+	may be used to add or release the given ports or port ranges
+	to/from the already existing port list.
+	Example:
+	$ echo "1000-2000" > /proc/sys/net/ipv4/ip_local_reserved_ports
+	$ echo "add 3000-4000,5000" > /proc/sys/net/ipv4/ip_local_reserved_ports
+	$ echo "release 1500-3500" > /proc/sys/net/ipv4/ip_local_reserved_ports
+	$ cat /proc/sys/net/ipv4/ip_local_reserved_ports
+	1000-1499,3501-4000,5000
 
 	Note that ip_local_port_range and ip_local_reserved_ports
 	settings are independent and both are considered by the kernel
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..241fc5a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2805,6 +2805,8 @@ static int proc_do_cad_pid(struct ctl_table *table, int write,
  * We use a range comma separated format (e.g. 1,3-4,10-10) so that
  * large bitmaps may be represented in a compact manner. Writing into
  * the file will clear the bitmap then update it with the given input.
+ * If "add" or "release" is written in front of numbers or number ranges,
+ * the given bits will be added to or released from the existing bitmap.
  *
  * Returns 0 on success.
  */
@@ -2813,11 +2815,13 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 {
 	int err = 0;
 	bool first = 1;
+	bool add_or_release = 0, xadd = 0, xrelease = 0;
 	size_t left = *lenp;
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = (unsigned long *) table->data;
-	unsigned long *tmp_bitmap = NULL;
-	char tr_a[] = { '-', ',', '\n' }, tr_b[] = { ',', '\n', 0 }, c;
+	unsigned long *tmp_bitmap = NULL, *release_bitmap = NULL;
+	char tr_a[] = { '-', ',', ' ', '\n' },
+	     tr_b[] = { ',', ' ', '\n', 0 }, c;
 
 	if (!bitmap_len || !left || (*ppos && !write)) {
 		*lenp = 0;
@@ -2841,8 +2845,9 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
                 }
 		kbuf[left] = 0;
 
-		tmp_bitmap = kzalloc(BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long),
-				     GFP_KERNEL);
+		tmp_bitmap = kzalloc(2 * BITS_TO_LONGS(bitmap_len) *
+					sizeof(unsigned long), GFP_KERNEL);
+		release_bitmap = &tmp_bitmap[BITS_TO_LONGS(bitmap_len)];
 		if (!tmp_bitmap) {
 			free_page(page);
 			return -ENOMEM;
@@ -2850,7 +2855,30 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 		proc_skip_char(&kbuf, &left, '\n');
 		while (!err && left) {
 			unsigned long val_a, val_b;
-			bool neg;
+			bool neg, found;
+
+			left -= proc_skip_spaces(&kbuf);
+			if (!left)
+				continue;
+
+			found = (0 == strnicmp(kbuf, "add ", 4));
+			if (found) {
+				xadd = 1; xrelease = 0;
+				add_or_release = 1;
+				kbuf += 4;
+				left -= 4;
+			}
+			found = (0 == strnicmp(kbuf, "release ", 8));
+			if (found) {
+				xadd = 0; xrelease = 1;
+				add_or_release = 1;
+				kbuf += 8;
+				left -= 8;
+			}
+
+			left -= proc_skip_spaces(&kbuf);
+			if (!left)
+				continue;
 
 			err = proc_get_long(&kbuf, &left, &val_a, &neg, tr_a,
 					     sizeof(tr_a), &c);
@@ -2885,7 +2913,10 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 			}
 
 			while (val_a <= val_b)
-				set_bit(val_a++, tmp_bitmap);
+				if (xrelease)
+					set_bit(val_a++, release_bitmap);
+				else
+					set_bit(val_a++, tmp_bitmap);
 
 			first = 0;
 			proc_skip_char(&kbuf, &left, '\n');
@@ -2926,9 +2957,10 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 
 	if (!err) {
 		if (write) {
-			if (*ppos)
+			if (*ppos || add_or_release) {
 				bitmap_or(bitmap, bitmap, tmp_bitmap, bitmap_len);
-			else
+				bitmap_andnot(bitmap, bitmap, release_bitmap, bitmap_len);
+			} else
 				memcpy(bitmap, tmp_bitmap,
 					BITS_TO_LONGS(bitmap_len) * sizeof(unsigned long));
 		}
