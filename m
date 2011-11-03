Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab1KCPmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:42:16 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57982 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab1KCPmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:42:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
Date: Thu, 3 Nov 2011 15:42:13 +0000
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
To: Steve French <sfrench@samba.org>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I should add that we are using iocharset=utf8 mount option which means that the dcache hash/compare functions done in the cifs module do not work because it uses nls_tolower() and nls_strnicmp() both of which for utf8 NLS in the kernel do not do anything at all and effectively behave case sensitively!

Thus this bug/problem in all likelyhood only affects utf8 iocharset users on a case-insensitive but case-preserving CIFS server that does not support server inode numbers.

That probably explains why it has not been noticed before!

We need utf8 thus we still need to fix this issue.

Best regards,

	Anton

On 3 Nov 2011, at 15:20, Anton Altaparmakov wrote:

> Hi,
> 
> Our CIFS server problems seem to have no end…  The Novell CIFS server does not support server inode numbers (when I try the mount option I get the message it is being turned off as server does not support it) and thus each inode gets a different number each time it is accessed and it gets a different number again for each readdir call.
> 
> The fun happens with rename() when the rename source and target only differ in case, e.g.
> 
> 	touch foo
> 	mv foo Foo
> 
> The result?  Because of the difference in inode numbers, the request gets through to the CIFS module which promptly does:
> 
> 	cifs_unlink(target_dir, target_dentry)
> 	rc = cifs_do_rename(…)
> 
> And because the cifs_unlink() just removed the source of the rename (as it is the same as the target), "rc" comes back as -ENOENT.
> 
> And indeed the file is gone so we just lost the user's file for ever.  )-:
> 
> We are tossing around ideas how to fix this but we would be interested in your input as to what you think the fix should be.
> 
> In any case this probably should be fixed in the standard kernel CIFS module, too, and not just for us locally as this presumably affects anyone who is using the CIFS module against case-insensitive, non-server-inode-number-supporting CIFS servers...
> 
> Best regards,
> 
> 	Anton

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

