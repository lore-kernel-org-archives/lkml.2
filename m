Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1J3EtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 00:49:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50546 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1J3EtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 00:49:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
	<CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
	<20111025131315.GA1899@suse.de> <4EAC8642.3050309@suse.cz>
Date: Sat, 29 Oct 2011 21:49:47 -0700
In-Reply-To: <4EAC8642.3050309@suse.cz> (Jiri Slaby's message of "Sun, 30 Oct
	2011 01:03:30 +0200")
Message-ID: <m11utvytg4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/fG3XtiRegWdpDTe4P87mG0RVSlVkaiIA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Jiri Slaby <jslaby@suse.cz>
X-Spam-Relay-Country: **
Subject: Re: Broken link in /sys/class/net/ [was: [GIT] Networking]
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> On 10/25/2011 03:13 PM, Greg KH wrote:
>> On Tue, Oct 25, 2011 at 01:46:11PM +0200, Linus Torvalds wrote:
>>> Anyway, after that rant about really bad practices, let me say that I
>>> did fix up the conflict and I think it's right. But I won't guarantee
>>> it, so please check the changes to fs/sysfs/dir.c.
>> 
>> I think it looks ok, I've booted the merge result, and am typing and
>> sending this from the new kernel, and it hasn't crashed yet :)
>
> Hi, maybe this was not caused by the merge, but the patch[1] causes this
> mess in /sys/class/net/ for me:
> l????????? ? ?    ?    ?             ? eth1
>
> This happens after one renames a net device -- the new name is eth1 here.
>
> [1] 4f72c0cab40 (sysfs: use rb-tree for name lookups)

This looks pretty fixable but today sysfs_rename does not do anything
with the to move a renamed entry to a different position in the rbtree.

If the directory itself changes sysfs_rename should be fine, and it
looks like a trivial patch to always apply the directory rename logic
in sysfs_rename. 

I think all we need is something like the untested patch below to fix
the network device rename problem.

Eric

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 48ffbdf..a294068 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -865,14 +865,13 @@ int sysfs_rename(struct sysfs_dirent *sd,
 		sd->s_name = new_name;
 	}
 
-	/* Remove from old parent's list and insert into new parent's list. */
-	if (sd->s_parent != new_parent_sd) {
-		sysfs_unlink_sibling(sd);
-		sysfs_get(new_parent_sd);
-		sysfs_put(sd->s_parent);
-		sd->s_parent = new_parent_sd;
-		sysfs_link_sibling(sd);
-	}
+	/* Move to the appropriate place in the appropriate directories rbtree. */
+	sysfs_unlink_sibling(sd);
+	sysfs_get(new_parent_sd);
+	sysfs_put(sd->s_parent);
+	sd->s_parent = new_parent_sd;
+	sysfs_link_sibling(sd);
+
 	sd->s_ns = new_ns;
 
 	error = 0;

