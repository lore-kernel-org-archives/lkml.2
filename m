Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0KKVqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:46:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49126 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0KKVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dS9FyB0byVCT7CnjEYWRoQliJcd2Mm3iNGT4A48MHY3TqppHam4vNR37MN4Xinx+Ub
         /zhHCD9AHYFG6SpkvPLMjKCYAw/CziwnqfxA1YRMSDgTjLXq/eltx+io8AhVOCrjH7rq
         XY5hH8FLw3aJmJTCgCblTMeab5O8ORddjy6WQ=
Message-ID: <4CDC64B9.8070208@gmail.com>
Date: Thu, 11 Nov 2010 22:48:41 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100903 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, Lionel Debroux <lionel_debroux@yahoo.fr>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [Cocci] Re: status of constification
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com> <Pine.LNX.4.64.1011100727370.352@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1011100727370.352@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/10 07:35, Julia Lawall wrote:
>> I tried to automate the whole process with Coccinelle but I abandoned it
>> because Coccinelle didn't support recursive header file inclusion at the time.
>> If someone feels like fixing Coccinelle then I would quickly finish my script
>> (it has a few bugs because I could never test it for real), but see the end
>> of the mail for the current version. I think it would be a good idea because
>> it would take a few hours only to generate a constification patch for a new
>> kernel. One thing that probably cannot be automated with Coccinelle is that
>> once the script determines that a given structure cannot be constified, it
>> cannot undo already emitted patches for the given structure so it must be
>> cleaned up by post processing script.
> 
> What would the right approach be?  It is not obvious to find 100% of the 
> header files, because some of them depend on information in Makefiles.  

For 100% coverage you can look at how the Linux Makefiles invoke sparse.

> You can use that information by running the preprocessor on Coccinelle 
> first, but then the result is only useful for finding files that need 
> changing, but not actually making the changes because Coccinelle does not 
> relate the preprocessed code back to the original code.  But if you run 
> the preprocessor, you only get information for your current configuration, 
> which is probably not what you want.
> 
> Coccinelle could certainly get a new option -really_all_includes, or 
> something like that, that would recursively include among what it can find 
> and what has not been included already.  Would that be what is wanted?

Yes, this is exactly what I'd like to have, missing the few includes
you referred to above is not a problem for my purposes.

Thanks, Emese

> 
> I guess that in practice the includes are only being used for type 
> information?  Wouldn't it be safe to run the semantic patch based on the 
> includes that are available?
> 
> julia
> 
>>
>> --
>> Emese
>>
>>
>> // spatch.opt -sp_file $1 -include_headers -local_includes -all_includes -I "include/" -dir $2
>>
>> @initialize:python@
>> noconst = []
>>
>> @stc@
>> identifier idtype, y;
>> type t;
>> position p;
>> @@
>> struct idtype {
>> 	...
>> 	t (*y)(...);@p
>> 	...
>> };
>>
>> @notjustfp@
>> identifier stc.idtype, y;
>> type t;
>> position p != stc.p;
>> @@
>> struct idtype {
>> 	...
>> 	t y;@p
>> 	...
>> };
>>
>> @script:python depends on notjustfp@
>> @@
>> cocci.include_match(False)
>>
>> @variable@
>> identifier stc.idtype, idvariant, id;
>> @@
>> (
>> 	struct idtype idvariant = {
>> 		...
>> 	};
>> |
>> 	struct idtype idvariant;
>> |
>> 	struct idtype *idvariant;
>> |
>> 	struct id {
>> 		...
>> 		struct idtype idvariant;
>> 		...
>> 	};
>> )
>>
>> @script:python@
>> y << variable.idvariant;
>> @@
>> if y in noconst:
>> 	cocci.include_match(False)
>>
>> @alreadyconst@
>> identifier stc.idtype, variable.idvariant, id;
>> @@
>> (
>> 	const struct idtype idvariant;
>> |
>> 	const struct idtype idvariant = {
>> 		...
>> 	};
>> |
>> 	const struct idtype *idvariant;
>> |
>> 	struct id {
>> 		...
>> 		const struct idtype idvariant;
>> 		...
>> 	};
>> )
>>
>> @script:python depends on alreadyconst@
>> @@
>> cocci.include_match(False)
>>
>> @fn_declaration@
>> identifier stc.idtype, variable.idvariant, fn;
>> type t;
>> @@
>> t fn(struct idtype *idvariant);
>>
>> @fn_definition@
>> identifier stc.idtype, variable.idvariant, fn;
>> type t;
>> @@
>> t fn(struct idtype *idvariant)
>> {
>> 	...
>> }
>>
>> // TODO: handle var.field1.field2, var->field1->field2
>> @assignement@
>> identifier variable.idvariant, x, idptr;
>> @@
>> (
>> 	idvariant.x = ...;
>> |
>> 	idvariant->x = ...;
>> |
>> 	idptr = &idvariant;
>> 	...
>> 	idptr->x = ...;
>> |
>> 	memcpy(&idvariant, ...);
>> |
>> 	memcpy(idvariant.x, ...);
>> |
>> 	memcpy(idvariant->x, ...);
>> |
>> 	idvariant = kzalloc(...);
>> |
>> 	idvariant = kmalloc(...);
>> )
>>
>> @script:python depends on assignement@
>> x << stc.idtype;
>> y << variable.idvariant;
>> @@
>> print "Cannot be const: %s-%s" % (x, y)
>> noconst.append(y)
>> cocci.include_match(False)
>>
>> @depends on stc && !fn_declaration && !fn_definition@
>> identifier stc.idtype, variable.idvariant, id;
>> @@
>> (
>> -struct idtype idvariant = {
>> +const struct idtype idvariant = {
>> 		...
>>  };
>> |
>> -struct idtype idvariant;
>> +const struct idtype idvariant;
>> |
>> -struct idtype *idvariant;
>> +const struct idtype *idvariant;
>> |
>> -struct idtype *idvariant = NULL;
>> +const struct idtype *idvariant = NULL;
>> |
>> struct id {
>> ...
>> -struct idtype idvariant;
>> +const struct idtype idvariant;
>> ...
>>  };
>> )
>>
>> @depends on stc && fn_declaration && !fn_definition@
>> identifier stc.idtype, variable.idvariant, fn_declaration.fn;
>> type fn_declaration.t;
>> @@
>> t fn(
>> -struct idtype *idvariant
>> +const struct idtype *idvariant
>>  );
>>
>> @depends on stc && !fn_declaration && fn_definition@
>> identifier stc.idtype, variable.idvariant, fn_definition.fn;
>> type fn_definition.t;
>> @@
>> t fn(
>> -struct idtype *idvariant
>> +const struct idtype *idvariant
>>  )
>>  {
>>  	...
>>  }
>>
>>
> 

