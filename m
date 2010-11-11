Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab0KKWxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:53:40 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:42918 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab0KKWxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:53:39 -0500
Date: Thu, 11 Nov 2010 23:53:35 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Emese Revfy <re.emese@gmail.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, Lionel Debroux <lionel_debroux@yahoo.fr>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [Cocci] Re: status of constification
In-Reply-To: <4CDC64B9.8070208@gmail.com>
Message-ID: <Pine.LNX.4.64.1011112352030.27612@ask.diku.dk>
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com>
 <Pine.LNX.4.64.1011100727370.352@ask.diku.dk> <4CDC64B9.8070208@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Emese Revfy wrote:

> On 11/10/10 07:35, Julia Lawall wrote:
> >> I tried to automate the whole process with Coccinelle but I abandoned it
> >> because Coccinelle didn't support recursive header file inclusion at the time.
> >> If someone feels like fixing Coccinelle then I would quickly finish my script
> >> (it has a few bugs because I could never test it for real), but see the end
> >> of the mail for the current version. I think it would be a good idea because
> >> it would take a few hours only to generate a constification patch for a new
> >> kernel. One thing that probably cannot be automated with Coccinelle is that
> >> once the script determines that a given structure cannot be constified, it
> >> cannot undo already emitted patches for the given structure so it must be
> >> cleaned up by post processing script.
> > 
> > What would the right approach be?  It is not obvious to find 100% of the 
> > header files, because some of them depend on information in Makefiles.  
> 
> For 100% coverage you can look at how the Linux Makefiles invoke sparse.

I haven't looked at it, but I doubt it gives 100% coverage, because one 
can have code in both the if and else branches of an ifdef.  I would 
imagine that it gives 100% coverage for whatever architecture you would be 
compiling for?

julia

> > You can use that information by running the preprocessor on Coccinelle 
> > first, but then the result is only useful for finding files that need 
> > changing, but not actually making the changes because Coccinelle does not 
> > relate the preprocessed code back to the original code.  But if you run 
> > the preprocessor, you only get information for your current configuration, 
> > which is probably not what you want.
> > 
> > Coccinelle could certainly get a new option -really_all_includes, or 
> > something like that, that would recursively include among what it can find 
> > and what has not been included already.  Would that be what is wanted?
> 
> Yes, this is exactly what I'd like to have, missing the few includes
> you referred to above is not a problem for my purposes.
> 
> Thanks, Emese
> 
> > 
> > I guess that in practice the includes are only being used for type 
> > information?  Wouldn't it be safe to run the semantic patch based on the 
> > includes that are available?
> > 
> > julia
> > 
> >>
> >> --
> >> Emese
> >>
> >>
> >> // spatch.opt -sp_file $1 -include_headers -local_includes -all_includes -I "include/" -dir $2
> >>
> >> @initialize:python@
> >> noconst = []
> >>
> >> @stc@
> >> identifier idtype, y;
> >> type t;
> >> position p;
> >> @@
> >> struct idtype {
> >> 	...
> >> 	t (*y)(...);@p
> >> 	...
> >> };
> >>
> >> @notjustfp@
> >> identifier stc.idtype, y;
> >> type t;
> >> position p != stc.p;
> >> @@
> >> struct idtype {
> >> 	...
> >> 	t y;@p
> >> 	...
> >> };
> >>
> >> @script:python depends on notjustfp@
> >> @@
> >> cocci.include_match(False)
> >>
> >> @variable@
> >> identifier stc.idtype, idvariant, id;
> >> @@
> >> (
> >> 	struct idtype idvariant = {
> >> 		...
> >> 	};
> >> |
> >> 	struct idtype idvariant;
> >> |
> >> 	struct idtype *idvariant;
> >> |
> >> 	struct id {
> >> 		...
> >> 		struct idtype idvariant;
> >> 		...
> >> 	};
> >> )
> >>
> >> @script:python@
> >> y << variable.idvariant;
> >> @@
> >> if y in noconst:
> >> 	cocci.include_match(False)
> >>
> >> @alreadyconst@
> >> identifier stc.idtype, variable.idvariant, id;
> >> @@
> >> (
> >> 	const struct idtype idvariant;
> >> |
> >> 	const struct idtype idvariant = {
> >> 		...
> >> 	};
> >> |
> >> 	const struct idtype *idvariant;
> >> |
> >> 	struct id {
> >> 		...
> >> 		const struct idtype idvariant;
> >> 		...
> >> 	};
> >> )
> >>
> >> @script:python depends on alreadyconst@
> >> @@
> >> cocci.include_match(False)
> >>
> >> @fn_declaration@
> >> identifier stc.idtype, variable.idvariant, fn;
> >> type t;
> >> @@
> >> t fn(struct idtype *idvariant);
> >>
> >> @fn_definition@
> >> identifier stc.idtype, variable.idvariant, fn;
> >> type t;
> >> @@
> >> t fn(struct idtype *idvariant)
> >> {
> >> 	...
> >> }
> >>
> >> // TODO: handle var.field1.field2, var->field1->field2
> >> @assignement@
> >> identifier variable.idvariant, x, idptr;
> >> @@
> >> (
> >> 	idvariant.x = ...;
> >> |
> >> 	idvariant->x = ...;
> >> |
> >> 	idptr = &idvariant;
> >> 	...
> >> 	idptr->x = ...;
> >> |
> >> 	memcpy(&idvariant, ...);
> >> |
> >> 	memcpy(idvariant.x, ...);
> >> |
> >> 	memcpy(idvariant->x, ...);
> >> |
> >> 	idvariant = kzalloc(...);
> >> |
> >> 	idvariant = kmalloc(...);
> >> )
> >>
> >> @script:python depends on assignement@
> >> x << stc.idtype;
> >> y << variable.idvariant;
> >> @@
> >> print "Cannot be const: %s-%s" % (x, y)
> >> noconst.append(y)
> >> cocci.include_match(False)
> >>
> >> @depends on stc && !fn_declaration && !fn_definition@
> >> identifier stc.idtype, variable.idvariant, id;
> >> @@
> >> (
> >> -struct idtype idvariant = {
> >> +const struct idtype idvariant = {
> >> 		...
> >>  };
> >> |
> >> -struct idtype idvariant;
> >> +const struct idtype idvariant;
> >> |
> >> -struct idtype *idvariant;
> >> +const struct idtype *idvariant;
> >> |
> >> -struct idtype *idvariant = NULL;
> >> +const struct idtype *idvariant = NULL;
> >> |
> >> struct id {
> >> ...
> >> -struct idtype idvariant;
> >> +const struct idtype idvariant;
> >> ...
> >>  };
> >> )
> >>
> >> @depends on stc && fn_declaration && !fn_definition@
> >> identifier stc.idtype, variable.idvariant, fn_declaration.fn;
> >> type fn_declaration.t;
> >> @@
> >> t fn(
> >> -struct idtype *idvariant
> >> +const struct idtype *idvariant
> >>  );
> >>
> >> @depends on stc && !fn_declaration && fn_definition@
> >> identifier stc.idtype, variable.idvariant, fn_definition.fn;
> >> type fn_definition.t;
> >> @@
> >> t fn(
> >> -struct idtype *idvariant
> >> +const struct idtype *idvariant
> >>  )
> >>  {
> >>  	...
> >>  }
> >>
> >>
> > 
> 
> 
