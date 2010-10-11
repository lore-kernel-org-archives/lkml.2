Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0JKJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:27:25 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:10928 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab0JKJ1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:27:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19634.55413.877788.492484@pilspetsen.it.uu.se>
Date: Mon, 11 Oct 2010 11:27:17 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent
 kernels
In-Reply-To: <20101011024103.GH19804@ZenIV.linux.org.uk>
References: <20101007174948.GT19804@ZenIV.linux.org.uk>
	<AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
	<AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
	<20101010235256.GG19804@ZenIV.linux.org.uk>
	<20101011024103.GH19804@ZenIV.linux.org.uk>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro writes:
 > On Mon, Oct 11, 2010 at 12:52:56AM +0100, Al Viro wrote:
 > > On Sun, Oct 10, 2010 at 10:18:03PM +0200, Geert Uytterhoeven wrote:
 > > > >> This is on aranym-0.9.9-1 from Ubuntu/amd64.
 > > > >
 > > > > stat -L /proc/2/exec, otherwise you'll hit lstat() instead of stat().
 > > > > And FWIW 0.9.10-1 squeeze/amd64 also triggers here...
 > > > 
 > > > Still, just "stat: cannot stat `proc/2/exe': No such file or directory" here...
 > > 
 > > Interesting...  Which gcc version is used?
 > 
 > Argh...  OK, going through aranym with debugger has exhonorated it.  My
 > apologies ;-/  It *is* gcc in sid.  Testcase:
 > 
 > extern int foo(int);
 > void *bar(int n)
 > {
 >         return (void *)foo(n);
 > }
 > 
 > and gcc -S -O2 turns that into
 > bar:
 >         link.w %fp,#0
 >         unlk %fp
 >         jra foo
 > 
 > Spot the obvious bug...  BTW, why on the Earth does debian-ports m68k tree
 > use gcc-4.3 with Cthulhu-scaring 700Kb gzipped patch and does *not* have
 > gcc-4.4?

I can confirm that the bug exists in gcc-4.3.4 and gcc-4.4.5,
but it has been fixed in gcc-4.5.1 which generates:

bar:
        link.w %fp,#0
        move.l 8(%fp),-(%sp)
        jsr foo
        move.l %d0,%a0
        unlk %fp
        rts

I don't yet know the gcc PR number or svn commit # for the fix
(in case people want a backport).
