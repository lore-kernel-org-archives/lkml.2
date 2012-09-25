Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2IYKnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:43:05 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57820 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2IYKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:43:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com>
	<50615268.1040805@canonical.com>
	<8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
	<506173A6.2050705@canonical.com>
Date: Tue, 25 Sep 2012 03:42:50 -0700
In-Reply-To: <506173A6.2050705@canonical.com> (Maarten Lankhorst's message of
	"Tue, 25 Sep 2012 11:04:38 +0200")
Message-ID: <87ipb2pemt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/WJ+eHFOhvDQzUZ3093IHkJGj9a3S3yec=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0033]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Maarten Lankhorst <maarten.lankhorst@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:

> Hey,
>
> Op 25-09-12 09:05, Eric W. Biederman schreef:
>> Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>
>>> Hey,
>>>
>>> Op 25-09-12 05:39, Eric W. Biederman schreef:
>>>> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>>>>
>>>>> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>>>>>
>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>
>>>>> My thread about the regression seemed to have been ignored, so I can
>>> only
>>>>> conclude nobody objects against a full revert of this patch.
>>>>>
>>>>> My testcase is simply booting through netboot with / and ~/nfs as
>>> separate
>>>>> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a
>>> gnome-terminal
>>>>> window, then I get:
>>>> Do I read your description correctly:  Without using a bind mount you
>>>> have the same nfs filesystem mounted on / and on ~/nfs?
>>>>
>>>> Something is definitely off with your configuration but if to work
>>> you
>>>> need to move mount points around then that something seems much
>>> deeper
>>>> than the __d_unalias change.
>>>>
>>>> What filesystems do you have mounted where?
>>>>
>>> / is a nfs filesystem, ~/nfs is a different nfs filesystem.
>> Are both filesystems on the same server?
>>
>> Are the two filesystems distinct filesystem on the server?
>>
>> Unless there is duplication of something somewhere the d_unalias code should not trigger.
>
> They're both on the same physical filesystem on the server, but unique exports:
> /home/mlankhorst/nfs *(no_subtree_check,insecure,rw,all_squash,anonuid=1000,anongid=1000)
> /home/mlankhorst/kvm/quantal-amd64 *(no_subtree_check,insecure,rw,no_root_squash)

Modern NFS does some interesting things with disconnected roots and the
like.  I don't think it should be connecting those two filesytems
together because there are no overlapping directories.

I really don't get why using one filesystem causes confusion in the other.

> Rootfs is mounted by the kernel itself, I used a custom init script to mount /lib/modules
> early on:
>
> mount -t nfs -o nolock,vers=3 192.168.1.128:/home/mlankhorst/nfs /home/mlankhorst/nfs &&
> mkdir -p /lib/modules/$(uname -r)/kernel &&
> mount --bind /home/mlankhorst/nfs/linux /lib/modules/$(uname -r)/kernel &&
> ([ -f /lib/modules/$(uname -r)/modules.symbols ] || depmod)
>
> exec /sbin/init

Could you try the following patch?  This should report what directories
cannot be renamed because one of them is a mount point and it gives some
real insight into what is going on.

Eric


diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..193b7be 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2374,6 +2374,7 @@ struct dentry *d_ancestor(struct dentry *p1, struct dentry *p2)
 	return NULL;
 }
 
+static char *__dentry_path(struct dentry *dentry, char *buf, int buflen);
 /*
  * This helper attempts to cope with remotely renamed directories
  *
@@ -2401,6 +2402,18 @@ static struct dentry *__d_unalias(struct inode *inode,
 		goto out_err;
 	m2 = &alias->d_parent->d_inode->i_mutex;
 out_unalias:
+#if 1
+	if (d_mountpoint(alias)) {
+		static char buf1[8192];
+		static char buf2[8192];
+		char *alias_name, *dentry_name;
+		alias_name = __dentry_path(alias, buf1, sizeof(buf1));
+		dentry_name = __dentry_path(dentry, buf2, sizeof(buf2));
+
+		printk(KERN_DEBUG "%s: %s -> %s\n",
+		       __func__, alias_name, dentry_name);
+	}
+#endif
 	if (likely(!d_mountpoint(alias))) {
 		__d_move(alias, dentry);
 		ret = alias;
