Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1I3Xr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:47:27 -0400
Received: from fn.samba.org ([216.83.154.106]:35866 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1I3XrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:47:13 -0400
Date: Fri, 30 Sep 2011 16:47:11 -0700
From: Jeremy Allison <jra@samba.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Jeff Layton <jlayton@samba.org>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>
Subject: Re: CIFS  kernel module bug
Message-ID: <20110930234711.GD14147@samba2>
Reply-To: Jeremy Allison <jra@samba.org>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
 <20110930140409.51c1a94c@tlielax.poochiereds.net>
 <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:30:47PM +0100, Anton Altaparmakov wrote:
> 
> Yes, I am happy to do that.
> 
> Also a question for you: I am up to the neck in having to adapt the CIFS module as it doesn't work very well against the Novell Open Enterprise Server CIFS server (that is why I was looking at the CIFS code and noticed this logic bug in the first place).
> 
> A bit of background: the home directories for our (i.e. University of Cambridge Computing Service) Linux distribution "MCS Linux" which runs on about a thousand workstations and a handfull of remote access servers used to be on Netware and were moved to OES Linux recently and the ncpfs kernel module really fell over in a heap when running against the OES NCP server so we had to switch to CIFS in a hurry and whilst it does not fall over in a heap like ncpfs does and we now have working reconnects when the home directory server is rebooted (home directories magically start working again after the reboot which is brilliant!) many applications do not work.
> 
> I can only assume this is because the CIFS server is an abomination rather than that the CIFS modules is quite that badly broken…  Anyway, my question is: do you want patches that make the CIFS module work better with OES CIFS server or do you not care?
> 
> For example lots of applications require working hard links so I had to port our Virtual Hard Link implementation from NCPfs to CIFS to get hard links working which fixed a lot of applications but then we started hitting real bugs.  A few examples:
> 
> - llseek(SEEK_END) fails against the OES server with error -EBADF from the server because the SEEK_END causes file revalidation which ends up calling CIFSSMBQFileInfo() which then results in the -EBADF.  I wrote a patch to fall back to path based query via CIFSSMBQPathInfo() and if that fails via SMBQueryInformation() and now the llseek(SEEK_END) works thus applications like Seamonkey actually manage to launch rather than segfaulting.
> 
> - mkdir() returns -EACCES when the target exists.  Again this is coming from the OES server.  I wrote a patch that calls cifs_get_inode_info() when CIFSSMBMkDir() returns -EACCES and unix extensions are not enabled on the superblock and if the result is success I rewrite the return code to -EEXIST which fixes the mkdir issue and that fixes loads of Gnome related applications.
> 
> - The OES server behaves like NT4 in that it returns success from CIFSSMBSetPathInfo() but it actually ignores the call unless the file is open on the server.  But the OES server does not have CIFS_SES_NT4 in the session flags thus the work around in the CIFS module does not trigger and thus changing the access times or permissions does not work unless the file happens to be open which breaks applications like rsync.  I commented the CIFSSMBSetPathInfo() call completely in a patch so it falls back to the other code which makes it work for us.
> 
> And finally the actual question: Are you interested in any of these patches or at least are you interested in fixing these issues in the standard CIFS module in which case I can send you my patches or at least give you detailed descriptions of what is failing and how?

What server code is the OES CIFS server running ? I thought Novell CIFS
services were all Samba based.

Jeremy.
