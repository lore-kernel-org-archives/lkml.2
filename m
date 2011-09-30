Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab1I3Va5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:30:57 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:32999 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1I3Vau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:30:50 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: CIFS  kernel module bug
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20110930140409.51c1a94c@tlielax.poochiereds.net>
Date: Fri, 30 Sep 2011 22:30:47 +0100
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk> <20110930140409.51c1a94c@tlielax.poochiereds.net>
To: Jeff Layton <jlayton@samba.org>, Steve French <sfrench@samba.org>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 30 Sep 2011, at 19:04, Jeff Layton wrote:
> On Fri, 30 Sep 2011 14:58:58 +0100 Anton Altaparmakov <aia21@cam.ac.uk> wrote:
> 
>> Hi,
>> 
>> Looking at the current kernel (in Linus' repository on github) there is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llseek() there is this bit of code:
>> 
>> 	/*
>> 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>> 	 * the cached file length
>> 	 */
>> 	if (origin != SEEK_SET || origin != SEEK_CUR) {
>> 
>> The logical or should be a logical and, i.e. this should be:
>> 
>> 	if (origin != SEEK_SET && origin != SEEK_CUR) {
>> 
>> As the code is at present that line is ALWAYS true because origin is ALWAYS either != SEEK_SET or != SEEK_CUR as if it equals one it cannot equal the other and vice versa…
>> 
>> So at the moment it always does the revalidation instead of only for SEEK_END, SEEK_DATA, and SEEK_HOLE.
> 
> Haha, good catch. Care to roll up a patch to fix that?


Yes, I am happy to do that.

Also a question for you: I am up to the neck in having to adapt the CIFS module as it doesn't work very well against the Novell Open Enterprise Server CIFS server (that is why I was looking at the CIFS code and noticed this logic bug in the first place).

A bit of background: the home directories for our (i.e. University of Cambridge Computing Service) Linux distribution "MCS Linux" which runs on about a thousand workstations and a handfull of remote access servers used to be on Netware and were moved to OES Linux recently and the ncpfs kernel module really fell over in a heap when running against the OES NCP server so we had to switch to CIFS in a hurry and whilst it does not fall over in a heap like ncpfs does and we now have working reconnects when the home directory server is rebooted (home directories magically start working again after the reboot which is brilliant!) many applications do not work.

I can only assume this is because the CIFS server is an abomination rather than that the CIFS modules is quite that badly broken…  Anyway, my question is: do you want patches that make the CIFS module work better with OES CIFS server or do you not care?

For example lots of applications require working hard links so I had to port our Virtual Hard Link implementation from NCPfs to CIFS to get hard links working which fixed a lot of applications but then we started hitting real bugs.  A few examples:

- llseek(SEEK_END) fails against the OES server with error -EBADF from the server because the SEEK_END causes file revalidation which ends up calling CIFSSMBQFileInfo() which then results in the -EBADF.  I wrote a patch to fall back to path based query via CIFSSMBQPathInfo() and if that fails via SMBQueryInformation() and now the llseek(SEEK_END) works thus applications like Seamonkey actually manage to launch rather than segfaulting.

- mkdir() returns -EACCES when the target exists.  Again this is coming from the OES server.  I wrote a patch that calls cifs_get_inode_info() when CIFSSMBMkDir() returns -EACCES and unix extensions are not enabled on the superblock and if the result is success I rewrite the return code to -EEXIST which fixes the mkdir issue and that fixes loads of Gnome related applications.

- The OES server behaves like NT4 in that it returns success from CIFSSMBSetPathInfo() but it actually ignores the call unless the file is open on the server.  But the OES server does not have CIFS_SES_NT4 in the session flags thus the work around in the CIFS module does not trigger and thus changing the access times or permissions does not work unless the file happens to be open which breaks applications like rsync.  I commented the CIFSSMBSetPathInfo() call completely in a patch so it falls back to the other code which makes it work for us.

And finally the actual question: Are you interested in any of these patches or at least are you interested in fixing these issues in the standard CIFS module in which case I can send you my patches or at least give you detailed descriptions of what is failing and how?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

