Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0KIVwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:52:16 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53990 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0KIVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oRl3ssTXpOexUiKI9vgNo6oL7wDqbMyVmY8RMG4eMawGLoh2g2QeNNfVOOqUG3fg2W
         dJNmdmLJRC5XFCdTQ1T19n4ViDu9/h84QAqrYJJrIsavoCvcbKfRy8u+Cge0xlf3FByy
         0EtMrbR7rjD0JoyqwlO395Ag2V8X3O7wdx40A=
Message-ID: <4CD9C300.6040405@gmail.com>
Date: Tue, 09 Nov 2010 22:54:08 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100903 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: status of constification
References: <20101108223844.GS5876@outflux.net>
In-Reply-To: <20101108223844.GS5876@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/10 23:38, Kees Cook wrote:
> Hi,
> 
> So, I'm trying to come up to speed on what's still outstanding in the
> effort to constify function pointers. I saw patches from Emese Revfy
> go in, and I saw Lionel Debroux's recent patches. What already-created
> work still needs attention? I know there's more code to be written,
> but I'm trying to find any patches that have already been written but
> have not gone upstream yet.

Hi, 

I will gladly break up my current patch for the next -rc by structure
type or maintainer (some preferred it one way or the other) and send
it in some time next week so that you can handle the upstream submission
process (I will continue to maintain my patch in grsecurity).

There are many structures that can be constified, you can use the following
command to find most of them (use it on an allyesconfig kernel preferably):

grep _ops System.map |grep -Ewi 'b|d' | awk '{print $3}' | \
while read i ; do cscope -d -L -1 $i | grep -E "struct[ \t]*([^ ]*)[ \t]*" \
--color=none -o | awk '{print $2}' ; done |sort -u

Also there are always new instances of structures going in that should have
been constified.

I tried to automate the whole process with Coccinelle but I abandoned it
because Coccinelle didn't support recursive header file inclusion at the time.
If someone feels like fixing Coccinelle then I would quickly finish my script
(it has a few bugs because I could never test it for real), but see the end
of the mail for the current version. I think it would be a good idea because
it would take a few hours only to generate a constification patch for a new
kernel. One thing that probably cannot be automated with Coccinelle is that
once the script determines that a given structure cannot be constified, it
cannot undo already emitted patches for the given structure so it must be
cleaned up by post processing script.

--
Emese


// spatch.opt -sp_file $1 -include_headers -local_includes -all_includes -I "include/" -dir $2

@initialize:python@
noconst = []

@stc@
identifier idtype, y;
type t;
position p;
@@
struct idtype {
	...
	t (*y)(...);@p
	...
};

@notjustfp@
identifier stc.idtype, y;
type t;
position p != stc.p;
@@
struct idtype {
	...
	t y;@p
	...
};

@script:python depends on notjustfp@
@@
cocci.include_match(False)

@variable@
identifier stc.idtype, idvariant, id;
@@
(
	struct idtype idvariant = {
		...
	};
|
	struct idtype idvariant;
|
	struct idtype *idvariant;
|
	struct id {
		...
		struct idtype idvariant;
		...
	};
)

@script:python@
y << variable.idvariant;
@@
if y in noconst:
	cocci.include_match(False)

@alreadyconst@
identifier stc.idtype, variable.idvariant, id;
@@
(
	const struct idtype idvariant;
|
	const struct idtype idvariant = {
		...
	};
|
	const struct idtype *idvariant;
|
	struct id {
		...
		const struct idtype idvariant;
		...
	};
)

@script:python depends on alreadyconst@
@@
cocci.include_match(False)

@fn_declaration@
identifier stc.idtype, variable.idvariant, fn;
type t;
@@
t fn(struct idtype *idvariant);

@fn_definition@
identifier stc.idtype, variable.idvariant, fn;
type t;
@@
t fn(struct idtype *idvariant)
{
	...
}

// TODO: handle var.field1.field2, var->field1->field2
@assignement@
identifier variable.idvariant, x, idptr;
@@
(
	idvariant.x = ...;
|
	idvariant->x = ...;
|
	idptr = &idvariant;
	...
	idptr->x = ...;
|
	memcpy(&idvariant, ...);
|
	memcpy(idvariant.x, ...);
|
	memcpy(idvariant->x, ...);
|
	idvariant = kzalloc(...);
|
	idvariant = kmalloc(...);
)

@script:python depends on assignement@
x << stc.idtype;
y << variable.idvariant;
@@
print "Cannot be const: %s-%s" % (x, y)
noconst.append(y)
cocci.include_match(False)

@depends on stc && !fn_declaration && !fn_definition@
identifier stc.idtype, variable.idvariant, id;
@@
(
-struct idtype idvariant = {
+const struct idtype idvariant = {
		...
 };
|
-struct idtype idvariant;
+const struct idtype idvariant;
|
-struct idtype *idvariant;
+const struct idtype *idvariant;
|
-struct idtype *idvariant = NULL;
+const struct idtype *idvariant = NULL;
|
struct id {
...
-struct idtype idvariant;
+const struct idtype idvariant;
...
 };
)

@depends on stc && fn_declaration && !fn_definition@
identifier stc.idtype, variable.idvariant, fn_declaration.fn;
type fn_declaration.t;
@@
t fn(
-struct idtype *idvariant
+const struct idtype *idvariant
 );

@depends on stc && !fn_declaration && fn_definition@
identifier stc.idtype, variable.idvariant, fn_definition.fn;
type fn_definition.t;
@@
t fn(
-struct idtype *idvariant
+const struct idtype *idvariant
 )
 {
 	...
 }

