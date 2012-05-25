Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2EYUTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:19:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47175 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2EYUTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:19:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: kd6lvw@yahoo.com
Cc: linux-kernel@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1337889128.10617.YahooMailClassic@web84515.mail.ne1.yahoo.com>
Date: Fri, 25 May 2012 14:19:24 -0600
In-Reply-To: <1337889128.10617.YahooMailClassic@web84515.mail.ne1.yahoo.com>
	(kd6lvw@yahoo.com's message of "Thu, 24 May 2012 12:52:08 -0700
	(PDT)")
Message-ID: <87wr40ko8j.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19lK9L/K8TshMxqfoe6i29cGQzgcdiXoXY=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;kd6lvw@yahoo.com
X-Spam-Relay-Country: 
Subject: Regression Mounting /proc w/ kernel 3.4.0 - "uid" parameter no longer ignored.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kd6lvw@yahoo.com writes:

> --- On Thu, 5/24/12, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "D. Stussy" <spam+newsgroups@bde-arc.ampr.org> writes:
>> > proc:  unrecognized mount option "uid=1" or missing value
>> >
>> > This works under 3.3.6 and earlier (I never tried 3.3.7).  It appears that the
>> > "uid" mount option was removed.  WHY?  More importantly, where is this change
>> > listed?  I didn't see it in the git log.
>> >
>> > This is really bad as I rebooted a remotely colocated server and since the
>> > procfs is not mounted, I cannot log in via SSH to correct the problem.
>> >
>> > OK, so there's not that much point in changing the UID of the procfs files, but
>> > I preferred to set their default ownership to a non-privileged user. 
>> 
>> There has never been a uid= option to /proc in Linus's tree.  I believe
>> if you look you will find this feature was from a patch (perhaps from
>> your distro) that added that support.
>
> I compile both the util-linux-ng and the kernel from source.  There is no distribution patch involved.  As noted, kernel version 3.3.6 didn't bitch about the setting, while 3.4.0 does and won't mount procfs.
>
> From the man page (copy at "http://linux.die.net/man/8/mount"):
>
> "Mount options for proc
>
>      "uid=value and gid=value 
>
> "These options are recognized, but have no effect as far as I can see."
>
>
> Removal of this compatibility should have been noted.  WHERE was it
> noted?  Linux.die.net is a distribution independent documentation
> site.  It might not do anything, but per mount's documentation, it is
> acceptable.

The only possible change to /proc that could have cause this behavior
between 3.3 and 3.4 is below.

Not ignoring options seems to be a regression that has affected your
setup on 3.4.

My gut feel is that we should revert all of the /proc option parsing
code as it is ugly code and apparently it could not have been used
before 3.4 so no one can be depending on it.  But I just want an excuse
to get rid of ugly code.  Accepting that /proc ignores all options
passed ot it as part of the ABI and not being able to add any options
to /proc ever is also a pretty horrible state to be in.

Shrug I will let you and the parties involved in creating this
regression figure this out.

Eric

ommit 99663be772c827b8f5f594fe87eb4807be1994e5
Author: Vasiliy Kulikov <segoon@openwall.com>
Date:   Thu Apr 5 14:25:04 2012 -0700

    proc: fix mount -t proc -o AAA
    
    The proc_parse_options() call from proc_mount() runs only once at boot
    time.  So on any later mount attempt, any mount options are ignored
    because ->s_root is already initialized.
    
    As a consequence, "mount -o <options>" will ignore the options.  The
    only way to change mount options is "mount -o remount,<options>".
    
    To fix this, parse the mount options unconditionally.
    
    Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
    Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
    Tested-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 46a15d8..eed44bf 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
        if (IS_ERR(sb))
                return ERR_CAST(sb);
 
+       if (!proc_parse_options(options, ns)) {
+               deactivate_locked_super(sb);
+               return ERR_PTR(-EINVAL);
+       }
+
        if (!sb->s_root) {

