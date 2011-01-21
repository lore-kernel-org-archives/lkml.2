Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1AUVzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:55:53 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:50669 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab1AUVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:55:52 -0500
X-Greylist: delayed 1096 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2011 16:55:52 EST
Subject: Re: SELinux/SMACK/TOMOYO: ioctl permissions handling is wrong and
 nonsensicle
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@tycho.nsa.gov, jmorris@namei.org, casey@schaufler-ca.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        takedakn@nttdata.co.jp
In-Reply-To: <1295638239.3403.15.camel@localhost.localdomain>
References: <1295638239.3403.15.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Fri, 21 Jan 2011 16:37:05 -0500
Message-ID: <1295645825.10909.5.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 14:30 -0500, Eric Paris wrote:
> [I've included an AA person as well in case you ever decide to try to
> mediate ioctl operations]
> 
> SELinux used to recognize certain individual ioctls and check
> permissions based on the knowledge of the individual ioctl.  In commit
> 242631c49d4cf396 the SELinux code stopped trying to understand
> individual ioctls and to instead looked at the ioctl access bits to
> determine in we should check read or write for that operation.  This
> same suggestion was made to SMACK (and I believe copied into TOMOYO).
> But this suggestion is total rubbish.  The ioctl access bits are
> actually the access requirements for the structure being passed into the
> ioctl, and are completely unrelated to the operation of the ioctl or the
> object the ioctl is being performed upon.
> 
> Take FS_IOC_FIEMAP as an example.  FS_IOC_FIEMAP is defined as:
> 
> FS_IOC_FIEMAP _IOWR('f', 11, struct fiemap)
> 
> So it has access bits R and W.  What this really means is that the
> kernel is going to both read and write to the struct fiemap.  It has
> nothing at all to do with the operations that this ioctl might perform
> on the file itself!
> 
> If anything, our logic is exactly backwards, since an ioctl which writes
> to userspace would be 'reading' something from the file and an ioctl
> which reads from userspace would be 'writing' something to the file...
> 
> I'm planning to revert this SELinux commit, but I want other LSM authors
> to realize that (assuming I'm not completely off in the woods somewhere)
> you should take a look at your ioctl permissions checking as well....

That's unfortunate.  Prior attempt to address ioctl was here:
http://marc.info/?l=linux-security-module&m=113088357020104&w=2

Which led to the approach based on _IOC_DIR.

We could revisit that approach, or just give up and always check
FILE__IOCTL unconditionally. I don't think we want to go back to
interpreting ioctl commands in the hook, as it is a layering violation
and same ioctl command value could mean different things for different
underlying objects.

-- 
Stephen Smalley
National Security Agency

