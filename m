Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0EZKWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:22:38 -0400
Received: from gw1.transmode.se ([213.115.205.20]:34133 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0EZKWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:22:36 -0400
In-Reply-To: <20100526171424.447fac18.sfr@canb.auug.org.au>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>	<20100525182040.f1882d0a.akpm@linux-foundation.org>
	<20100526140900.5b091c16.sfr@canb.auug.org.au>	<OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
	<20100525234116.71889c71.akpm@linux-foundation.org> <20100526171424.447fac18.sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning in Linus'tree
X-KeepSent: E5212A1C:B62E8E51-C125772F:00371EE7;
 type=4; name=$KeepSent
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OFE5212A1C.B62E8E51-ONC125772F.00371EE7-C125772F.0038EEC8@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 26 May 2010 12:21:51 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-05-26 12:22:35
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2010/05/26 09:14:24:
>
> Hi Andrew, Joakim,
>
> On Tue, 25 May 2010 23:41:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 26 May 2010 08:29:45 +0200 Joakim Tjernlund
> <joakim.tjernlund@transmode.se> wrote:
> >
> > > Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2010/05/26 06:09:00:
> > > >
> > > > On Tue, 25 May 2010 18:20:40 -0700 Andrew Morton <akpm@linux-
> foundation.org> wrote:
> > > > >
> > > > > hmpf.  Does this fix?
> > > >
> > > > No.
> > > >
> > > > The problem is that __LITTLE_ENDIAN is only defined in
> > > > linux/byteorder/little_endian.h which is only included by little endian
> > > > architectures ...
> > >
> > > Ah, not sure how to fix this ATM. Perhaps best to revert
> > >    crc32: use __BYTE_ORDER macro for endian detection
> > > for now.
> >
> > yup.
>
> We also need to revert b3b77c8caef1750ebeea1054e39e358550ea9f55 ("endian:
> #define __BYTE_ORDER") in order to get rid of the other warning I pointed out:
>
> In file included from fs/jfs/jfs_types.h:33,
>                  from fs/jfs/jfs_incore.h:26,
>                  from fs/jfs/file.c:22:
> fs/jfs/endian24.h:36:101: warning: "__LITTLE_ENDIAN" is not defined
>
> I get this warning on powerpc builds for most of the files in fs/jfs ...

endian24.h has:
#if (defined(__KERNEL__) && defined(__LITTLE_ENDIAN)) || (defined(__BYTE_ORDER) && (__BYTE_ORDER == __LITTLE_ENDIAN))
That won't work for BE CPU's. Perhaps something like this will?
#if defined(__BIG_ENDIAN) && defined(__LITTLE_ENDIAN) && (__BYTE_ORDER == __LITTLE_ENDIAN) || defined(__LITTLE_ENDIAN)

The kernel borrows __LITTLE_ENDIAN/__BIG_ENDIAN from user space but does not impl. the
full semantics that user space has. Adding full user space semantics isn't easy as it clashes with
current use of __LITTLE_ENDIAN/__BIG_ENDIAN.

If my suggestion above works, then one could start transforming current uses of __BYTE_ORDER,
into similar constructs and once all are done, #define both __LITTLE_ENDIAN/__BIG_ENDIAN and
move back to #if __BYTE_ORDER == __LITTLE_ENDIAN

 Jocke

