Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1CVTz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:55:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:14274 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1CVTzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,226,1299484800"; 
   d="scan'208";a="670090273"
From: "Luck, Tony" <tony.luck@intel.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-kernel@vger.kernel.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
In-Reply-To: <1300783365.2735.12.camel@localhost>
Date: Tue, 22 Mar 2011 12:55:53 -0700
Message-Id: <4d88fec9598644f42@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

pstore_dump() can be called with many different "reason" codes. Save
the name of the code in the persistent store record.

Also - only worthwhile calling pstore_mkfile for KMSG_DUMP_OOPS - that
is the only one where the kernel will continue running.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Artem Bityutskiy said:
> If you ask me, this smells like policy in the kernel. I'd look into the
> direction of having only the mechanisms in the kernel and letting the
> user-space making policy decisions by choosing what he wants to filter
> out and what he wants to store via some pstore interfaces.

Perhaps I'll just leave all the policy out then and keep logging
the same for all dmesg reason codes.  Seiji Aguchi sounded quite
lukewarm to the idea of logging less for shutdown/restart etc.
Providing an option that lets the user ask pstore to filter away
the restart/shutdown logs would defeat the purpose for which these
reason codes were added - providing a neat trail that simple tools
can use to show that a system rebooted because some root process
issued a reboot(2) syscall.

Here's a simpler clean up of the fs/pstore/platform.c code that
makes sure that we log a meaningful string for each reason code
(rather than "Oops"!) and that only tries to add an entry to the
mounted filesystem for the KMSG_TYPE_OOPS case (since that is the
only case where the system stays up for some process to see it).

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index ce9ad84..f835a25 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -48,6 +48,10 @@ void pstore_set_kmsg_bytes(int bytes)
 /* Tag each group of saved records with a sequence number */
 static int	oopscount;
 
+static char *reason_str[] = {
+	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
+};
+
 /*
  * callback from kmsg_dump. (s2,l2) has the most recently
  * written bytes, older bytes are in (s1,l1). Save as much
@@ -61,15 +65,20 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	unsigned long	s1_start, s2_start;
 	unsigned long	l1_cpy, l2_cpy;
 	unsigned long	size, total = 0;
-	char		*dst;
+	char		*dst, *why;
 	u64		id;
 	int		hsize, part = 1;
 
+	if (reason < ARRAY_SIZE(reason_str))
+		why = reason_str[reason];
+	else
+		why = "Unknown";
+
 	mutex_lock(&psinfo->buf_mutex);
 	oopscount++;
 	while (total < kmsg_bytes) {
 		dst = psinfo->buf;
-		hsize = sprintf(dst, "Oops#%d Part%d\n", oopscount, part++);
+		hsize = sprintf(dst, "%s#%d Part%d\n", why, oopscount, part++);
 		size = psinfo->bufsize - hsize;
 		dst += hsize;
 
@@ -86,7 +95,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
 
 		id = psinfo->write(PSTORE_TYPE_DMESG, hsize + l1_cpy + l2_cpy);
-		if (pstore_is_mounted())
+		if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
 				      psinfo->buf, hsize + l1_cpy + l2_cpy,
 				      CURRENT_TIME, psinfo->erase);
