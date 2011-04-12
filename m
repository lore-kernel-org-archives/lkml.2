Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1DLUNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756609Ab1DLUN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:13:29 -0400
Date: Tue, 12 Apr 2011 16:13:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110412201322.GA17246@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com>
 <20110412192103.GA13278@redhat.com>
 <BANLkTin6CTjxJLW49ExgFzS6-vne2gdH5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin6CTjxJLW49ExgFzS6-vne2gdH5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 12:55:24PM -0700, Linus Torvalds wrote:
 > On Tue, Apr 12, 2011 at 12:21 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
 > >
 > > perhaps adding that string to the end of the line would preserve what mount expects ?
 > 
 > Care to test? Otherwise I'll just revert the thing.. It's clearly not
 > valid behavior to randomly add some new field into the middle of a
 > /proc file.

Moving it to the EOL seems to restore things to how it looked in .38
I don't know if this breaks anything else. (I haven't dug to see why that
field was added, so I don't know what tool is using it, or what was used
to test the original patch in the first place).

	Dave

-- 

93f1c20bc8cdb757be50566eff88d65c3b26881f added a uuid field in the middle of
a line in /proc/self/mountinfo.  This broke the ABI expected by mount(8).
Moving it to the end restores the output to what it expects.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/fs/namespace.c b/fs/namespace.c
index 7dba2ed..cc2df9d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1085,10 +1085,6 @@ static int show_mountinfo(struct seq_file *m, void *v)
 	if (IS_MNT_UNBINDABLE(mnt))
 		seq_puts(m, " unbindable");
 
-	if (!uuid_is_nil(mnt->mnt_sb->s_uuid))
-		/* print the uuid */
-		seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
-
 	/* Filesystem specific data */
 	seq_puts(m, " - ");
 	show_type(m, sb);
@@ -1105,6 +1101,10 @@ static int show_mountinfo(struct seq_file *m, void *v)
 		goto out;
 	if (sb->s_op->show_options)
 		err = sb->s_op->show_options(m, mnt);
+	if (!uuid_is_nil(mnt->mnt_sb->s_uuid))
+		/* print the uuid */
+		seq_printf(m, " uuid:%pU", mnt->mnt_sb->s_uuid);
+
 	seq_putc(m, '\n');
 out:
 	return err;

