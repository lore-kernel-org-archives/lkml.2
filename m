Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab2I1TIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:08:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030835Ab2I1THF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Jakub=20Hus=C3=A1k?= <jakub@gooseman.cz>,
        NeilBrown <neilb@suse.de>
Subject: =?UTF-8?q?=5B=20259/262=5D=20md/raid10=3A=20fix=20=22enough=22=20function=20for=20detecting=20if=20array=20is=20failed=2E?=
Date: Fri, 28 Sep 2012 11:53:08 -0700
Message-Id: <20120928183029.124292052@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 80b4812407c6b1f66a4f2430e69747a13f010839 upstream.

The 'enough' function is written to work with 'near' arrays only
in that is implicitly assumes that the offset from one 'group' of
devices to the next is the same as the number of copies.
In reality it is the number of 'near' copies.

So change it to make this number explicit.

This bug makes it possible to run arrays without enough drives
present, which is dangerous.
It is appropriate for an -stable kernel, but will almost certainly
need to be modified for some of them.

Reported-by: Jakub Husák <jakub@gooseman.cz>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1492,14 +1492,16 @@ static int _enough(struct r10conf *conf,
 	do {
 		int n = conf->copies;
 		int cnt = 0;
+		int this = first;
 		while (n--) {
-			if (conf->mirrors[first].rdev &&
-			    first != ignore)
+			if (conf->mirrors[this].rdev &&
+			    this != ignore)
 				cnt++;
-			first = (first+1) % geo->raid_disks;
+			this = (this+1) % geo->raid_disks;
 		}
 		if (cnt == 0)
 			return 0;
+		first = (first + geo->near_copies) % geo->raid_disks;
 	} while (first != 0);
 	return 1;
 }


