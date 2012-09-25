Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2IYLaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:30:07 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33714 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2IYLaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:30:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com>
	<50615268.1040805@canonical.com>
	<8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
	<506173A6.2050705@canonical.com> <87ipb2pemt.fsf@xmission.com>
	<50618F96.1020204@canonical.com>
Date: Tue, 25 Sep 2012 04:29:58 -0700
In-Reply-To: <50618F96.1020204@canonical.com> (Maarten Lankhorst's message of
	"Tue, 25 Sep 2012 13:03:50 +0200")
Message-ID: <87sja6nxvt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19DbS6Q0klZZfgGP8SEM0v7cRkN2ZhlncY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0156]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Maarten Lankhorst <maarten.lankhorst@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:

>> Could you try the following patch?  This should report what directories
>> cannot be renamed because one of them is a mount point and it gives some
>> real insight into what is going on.
>
> ls /
> __d_unalias: /dev -> /dev
> __d_unalias: /proc -> /proc
> __d_unalias: /sys -> /sys

Ok.  That is what I thought was going on.  For some reason nfs is
attempting to recreate an existing dentry.

Does this fix the nfs problem for you?

Eric

diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..6390f0f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2404,6 +2404,9 @@ out_unalias:
 	if (likely(!d_mountpoint(alias))) {
 		__d_move(alias, dentry);
 		ret = alias;
+	} else if ((alias->d_parent == dentry->d_parent) &&
+		   !dentry_cmp(alias, dentry->d_name.name, dentry->d_name.len))
+		ret = alias;
 	}
 out_err:
 	spin_unlock(&inode->i_lock);


