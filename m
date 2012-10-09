Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2JIMjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab2JIMjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:39:42 -0400
Date: Tue, 9 Oct 2012 14:39:06 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-104.brq.redhat.com
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
cc: "=?ISO-8859-15?Q?'Luk=E1=A8_Czerner'?=" <lczerner@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Subject: RE: [PATCH 00/16] f2fs: introduce flash-friendly file system
In-Reply-To: <008301cda615$ca3b9980$5eb2cc80$%kim@samsung.com>
Message-ID: <alpine.LFD.2.00.1210091437460.17156@dhcp-1-104.brq.redhat.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com> <9DE65D03-D4EA-4B32-9C1D-1516EAE50E23@dubeyko.com> <1349553966.12699.132.camel@kjgkr> <50712AAA.5030807@gmail.com> <002201cda46e$88b84d30$9a28e790$%kim@samsung.com> <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com> <CAKYAXd_Y0Y0kLyqEm1FVO5TpvrN-WwnF40H3hMe5B7_cTe0nMw@mail.gmail.com> <004a01cda542$f398e2c0$dacaa840$%kim@samsung.com> <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
 <007c01cda60b$43e7fae0$cbb7f0a0$%kim@samsung.com> <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com> <008301cda615$ca3b9980$5eb2cc80$%kim@samsung.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Jaegeuk Kim wrote:

> > > > > > >
> > > > > > > As you can see the f2fs kernel document patch, I think one of the most
> > > > > > > important features is to align operating units between f2fs and ftl.
> > > > > > > Specifically, f2fs has section and zone, which are cleaning unit and basic
> > > > > > > allocation unit respectively.
> > > > > > > Through these configurable units in f2fs, I think f2fs is able to reduce the
> > > > > > > unnecessary operations done by FTL.
> > > > > > > And, in order to avoid changing IO patterns by the block-layer, f2fs merges
> > > > > > > itself some bios likewise ext4.
> > > > > > Hello.
> > > > > > The internal of eMMC and SSD is the blackbox from user side.
> > > > > > How does the normal user easily set operating units alignment(page
> > > > > > size and physical block size ?) between f2fs and ftl in storage device
> > > > > > ?
> > > > >
> > > > > I've known that some works have been tried to figure out the units by profiling the storage, AKA
> > > > reverse engineering.
> > > > > In most cases, the simplest way is to measure the latencies of consecutive writes and analyze
> > their
> > > > patterns.
> > > > > As you mentioned, in practical, users will not want to do this, so maybe we need a tool to
> > profile
> > > > them to optimize f2fs.
> > > > > In the current state, I think profiling is an another issue, and mkfs.f2fs had better include
> > this
> > > > work in the future.
> > > > > But, IMO, from the viewpoint of performance, default configuration is quite enough now.
> > > > >
> > > > > ps) f2fs doesn't care about the flash page size, but considers garbage collection unit.
> > > >
> > > > I am sorry but this reply makes me smile. How can you design a fs
> > > > relying on time attack heuristics to figure out what the proper
> > > > layout should be ? Or even endorse such heuristics to be used in
> > > > mkfs ? What we should be focusing on is to push vendors to actually
> > > > give us such information so we can properly propagate that
> > > > throughout the kernel - that's something everyone will benefit from.
> > > > After that the optimization can be done in every file system.
> > > >
> > >
> > > Frankly speaking, I agree that it would be the right direction eventually.
> > > But, as you know, it's very difficult for all flash vendors to promote and standardize that.
> > > Because each vendors have different strategies to open their internal information and also try
> > > to protect their secrets whatever they are.
> > >
> > > IMO, we don't need to wait them now.
> > > Instead, from the start, I suggest f2fs that uses those information to the file system design.
> > > In addition, I suggest using heuristics right now as best efforts.
> > > Maybe in future, if vendors give something, f2fs would be more feasible.
> > > In the mean time, I strongly hope to validate and stabilize f2fs with community.
> > 
> > Do not get me wrong, I do not think it is worth to wait for vendors
> > to come to their senses, but it is worth constantly reminding that
> > we *need* this kind of information and those heuristics are not
> > feasible in the long run anyway.
> > 
> > I believe that this conversation happened several times already, but
> > what about having independent public database of all the internal
> > information about hw from different vendors where users can add
> > information gathered by the time attack heuristic so other does not
> > have to run this again and again. I am not sure if Linaro or someone
> > else have something like that, someone can maybe post a link to that.
> > 
> 
> As I mentioned, I agree to push vendors to open those information all the time.
> And, I absolutely didn't mean that it is worth to wait vendors.
> I meant, until opening those information by vendors, something like
> proposing f2fs or gathering heuristics are also needed simultaneously.
> 
> Anyway, it's very interesting to build a database gathering products' information.
> May I access the database?

That's what I found:

https://wiki.linaro.org/WorkingGroups/Kernel/Projects/FlashCardSurvey

-Lukas

> 
> Thanks,
> 
> > Eventually we can show this to the vendors to see that their
> > "secrets" are already public anyway and that everyones lives would be
> > easier if they just agree to provide it from the beginning.
> > 
> > >
> > > > Promoting time attack heuristics instead of pushing vendors to tell
> > > > us how their hardware should be used is a journey to hell and we've
> > > > been talking about this for a looong time now. And I imagine that
> > > > you especially have quite some persuasion power.
> > >
> > > I know. :)
> > > If there comes a chance, I want to try.
> > > Thanks,
> > 
> > That's very good to hear, thank you.
> > 
> > -Lukas
