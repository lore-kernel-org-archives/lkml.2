Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab1BPEso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:48:44 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45771 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab1BPEsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:48:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=gL3F4AIgKweQ/YZX0GlsOU1SbDsAoOTzjg13e/Ai1VeB+VtFGk5Q5/9ewckda554WY
         ytQigqlCSOfjVgBDsW6GeGeZoRfsvtGXf49xYwdQ7sKvMQfMXNRE8KE/qSwBF+OO2xiJ
         jauBa2/ZI+yuT6l5EUIxhDN95s55t3XIppc8g=
Date: Wed, 16 Feb 2011 05:48:32 +0100
From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, rdunlap@xenotime.net,
        akpm@linux-foundation.org, andrea.gelmini@gelma.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH] [ANNOUNCE] kconfig: Kconfiglib: a flexible Python
 Kconfig parser
Message-ID: <20110216044830.GA19364@ulf>
Mail-Followup-To: Ulf Magnusson <ulfalizer.lkml@gmail.com>,
	Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	rdunlap@xenotime.net, akpm@linux-foundation.org,
	andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
References: <20110201232750.GA30800@ulf>
 <4D54715C.6060909@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D54715C.6060909@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 12:14:36AM +0100, Michal Marek wrote:
> On 2.2.2011 00:27, Ulf Magnusson wrote:
> > Hi,
> > 
> > This is the initial release of Kconfiglib: a Python library for
> > scripting, debugging, and extracting information from Kconfig-based
> > configuration systems.  It can be used to programmatically generate a
> > .config when the '*conf' tools are too inflexible, to quickly find out
> > interesting information about a Kconfig configuration such as dependency
> > relations between symbols and where undefined symbols are referenced,
> > and in applications that need to parse and extract information from
> > Kconfig files.
> > 
> > For a much longer introduction including multiple examples, see
> > arch/kconfig/kconfiglib.py.
> 
> Hi,
> 
> this looks like a very powerful tool, but I have a similar concern like
> Arnaud had - being completely standalone, it reimplements most of the C
> kconfig code. One option to reduce this duplication would be a swig
> wrapper, another one would be to let the C code parse the Kconfig files
> and write the required information in some digested form, that would be
> easier to parse by scripts. Something like:
> $ scripts/kconfig/conf_inspect --kconfig=Kconfig --eval='FOO || BAR'
> y
> $ scripts/kconfig/conf_inspect ... --dump-symbols
> config FOO
> type: bool
> valule: m
> visible: y
> prompt: "zzz"
> depends: X & Y
> select: Z
> ...
> $ scripts/kconfig/conf_inspect ... --dump-symbols \
>     --fields='depends,select,value'
> config FOO
> depends: X & Y
> select: Z
> value: m
> 
> config BAR
> ...
> 
> etc. The idea is that for instance instead of parsing the Kconfig files,
> the Python code could fill it's data structures by reading the flat dump
> provided by the C kconfig. There would be still lot to do in Python,
> e.g. parsing and evaluating expressions, but it would be a small step
> forward already. And people wanting to write quick&dirty scripts in
> bash/awk/perl would make use of the C code as well.
>
Offloading some of the parsing to a new tool would probably be doable,
though some Kconfig subleties might complicate things. For example,
symbols that appear within choices aren't seen as real selectable choice
items if they depend on previous symbols in specific ways (see
_determine_actual_items() in kconfiglib.py), and capturing this
information in the output while at the same preserving the ordering of
the symbols could be messy. I guess you could sort this out within
Kconfiglib instead, though other tools might then have to reimplement
the same (messy) rules.

I'm not so sure about offloading anything else this way. For dynamically
updating symbol values in a script you would need to somehow preserve
state between invocations (or pass huge lists of assignments back and
forth), which could lead to an unwieldy protocol. You might need to go
the SWIG route instead.

/Ulf
