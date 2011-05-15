Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab1EOQ34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:29:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34260 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043Ab1EOQ3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ssMl+DoD/51HWebTEV/QI4yM2Q8KeU9f2viPraNDZqH8/JGFDStA9hjP4CAuFLhO1V
         CkriYsUvg4q2tc/qxGTLcXs0vODIcoNK5Ndxh50TU11BJUZKtfGoo2cRixaajcsEvVtW
         dCPdF2kH3MaIc6rDe7DFU60Zk2x/5Y8eM7VB4=
Subject: Re: Possible coding issue in udf??
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Davis <alex14641@yahoo.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <m2k4dsnghx.fsf@firstfloor.org>
References: <367853.39582.qm@web130121.mail.mud.yahoo.com>
	 <m2k4dsnghx.fsf@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 18:29:50 +0200
Message-ID: <1305476990.3120.154.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 15 mai 2011 à 08:14 -0700, Andi Kleen a écrit :
> Alex Davis <alex14641@yahoo.com> writes:
> 
> > In fs/udf/inode.c, line 1455, linux 2.6.35, there is the following code:
> >
> > 	udfperms = ((inode->i_mode & S_IRWXO)) |
> > 		   ((inode->i_mode & S_IRWXG) << 2) |
> > 		   ((inode->i_mode & S_IRWXU) << 4);
> >
> > Shouldn't we be shifting by 3 bits? i.e:
> > 	udfperms = ((inode->i_mode & S_IRWXO)) |
> > 		   ((inode->i_mode & S_IRWXG) << 3) |
> > 		   ((inode->i_mode & S_IRWXU) << 6);
> >
> > The S_I.. constants are all defined in include/linux/stat.h as 3-bit values.
> >
> > I will send a patch if needed.
> 
> I  would suggest you test it first. Put in a UDF disk that triggers
> this case (verify with a printk). Check in ls -l if the 
> permissions are correct or wrong.

Well, no need to test ;)

Existing code is fine AFAIK.

fs/udf/ecma_167.h

/* Permissions (ECMA 167r3 4/14.9.5) */
#define FE_PERM_O_EXEC                  0x00000001U
#define FE_PERM_O_WRITE                 0x00000002U
#define FE_PERM_O_READ                  0x00000004U

#define FE_PERM_O_CHATTR                0x00000008U
#define FE_PERM_O_DELETE                0x00000010U

#define FE_PERM_G_EXEC                  0x00000020U
#define FE_PERM_G_WRITE                 0x00000040U
#define FE_PERM_G_READ                  0x00000080U

#define FE_PERM_G_CHATTR                0x00000100U
#define FE_PERM_G_DELETE                0x00000200U

#define FE_PERM_U_EXEC                  0x00000400U
#define FE_PERM_U_WRITE                 0x00000800U
#define FE_PERM_U_READ                  0x00001000U
#define FE_PERM_U_CHATTR                0x00002000U
#define FE_PERM_U_DELETE                0x00004000U


So Other bits (inode->i_mode & S_IRWXO) really maps to
FE_PERM_O_EXEC/WRITE/READ

For Group bits (inode->i_mode & S_IRWXG) we must shift by 2 bits to the
left to make them match FE_PERM_G_EXEC/WRITE/READ  (to skip
O_CHATR/O_DELETE)

For Owner/User bits (inode->i_mode & S_IRWXU) we must shift by 4 bits
for same reason.



