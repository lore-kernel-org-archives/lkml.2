Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0KFQY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 12:24:29 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:42079 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0KFQY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 12:24:28 -0400
Date: Sat, 6 Nov 2010 17:24:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
Message-ID: <20101106162426.GA14361@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aalmcv0p.fsf@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 11:49:10AM -0400, Ben Gamari wrote:
> On Sat, 06 Nov 2010 11:07:48 -0400, Ben Gamari <bgamari.foss@gmail.com> wrote:
> > On Fri, 30 Jul 2010 16:43:53 +0800, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > > This is useful. :) Looks like parse_dep_file() accesses out of
> > > the mmap'ed memory range...
> > > 
> > Did anything ever happen with this? I seem to be experiencing similar
> > issues while cross-compiling for ARM on x86-64. All tested kernels
> > (v2.6.35 to master) fail with,

Too k a quick look.
Does the following patch fix it?

if m == p then we will stay in the while look looking for a space.
I did not audit all of the code - there may be other issues..

	Sam

diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index ea26b23..f472ada 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -318,7 +318,7 @@ static void parse_dep_file(void *map, size_t len)
 		while (m < end && (*m == ' ' || *m == '\\' || *m == '\n'))
 			m++;
 		p = m;
-		while (p < end && *p != ' ') p++;
+		while (p <= end && *p != ' ') p++;
 		if (p == end) {
 			do p--; while (!isalnum(*p));
 			p++;

