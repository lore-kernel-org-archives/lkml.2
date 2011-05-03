Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1ECQ3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873Ab1ECQ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:29:11 -0400
MIME-Version: 1.0
In-Reply-To: <web-516990066@zbackend1.aha.ru>
References: <web-516671337@zbackend1.aha.ru> <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 May 2011 08:22:49 -0700
Message-ID: <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf3079ba82b8f48704a260b783
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3079ba82b8f48704a260b783
Content-Type: text/plain; charset=KOI8-R

2011/5/3 werner <w.landgraf@ru.ru>:
> Pls watch the config enclosed.
>
> IDE on , X86_EXTENDED_PLATFORM off (also X_86 elan)
>
> From the previous two suggestions, MTD on (appearently don't makes
> problems), but of MISC-FILESYSTEMS what appearently causes the error message
> during boot and perhaps also that sync don't work, I switched on the half
> and off the other half, to circle the problem.

Ok, can you try the attached patch, to see if the logfs oops goes
away. Perhaps  more importantly, does the sync problem also go away?

> No problem with unzip / zip / moving big files etc, , so that this problem
> cames from X86_EXTENDED_PLATTFORM.

Ok, that is very interesting.

> Tell me what to try out now

So at this point you have two problems, and I really would like to
just doubly verify both of them. First off, the attached patch for the
logfs oops and (hopefully) the sync hanging issue.

But secondly, I want you to double--check that whole CONFIG_X86_ELAN
thing - I'd like you to test two kernels that are otherwise totally
identical in their configurations, except one has
CONFIG_X86_EXTENDED_PLATTFORM on and CONFIG_X86_ELAN, and the other
does not.  Just to make sure that with all the changes to the config
file, that is really the _only_ difference, and that yes, that's the
one that brings up the "crash at unzip" problem.

I'm adding Ingo Molnar, Thomas Gleixner Peter Anvin to the cc, because
if this whole problem really is because of the x86 CPU configuration,
they may have better ideas than I do.

Ingo/Thomas/Peter: see the whole long and confused thread on lkml. But
it all boils down to Werner using a very full kernel config where not
only is almost everything compiled in (which showed the logfs problem
even though Werner didn't even have a logfs filesystem), but he also
had a very generic x86 kernel. Too generic.

He had CONFIG_X86_EXTENDED_PLATTFORM and CONFIG_X86_ELAN on, and that
has apparently worked for him (and a lot of other people - he does a
distribution) up until 2.6.38. But as of 2.6.39-rc1 it causes some
really odd problems under IO (his test-case is "unzip", but that's
probably fairly random). The problem seems to show up as a bogus IO
list for SATA, causing a big WARN_ON() or oops and then a dead machine
due to IO problems.

I wonder what CONFIG_X86_ELAN has to do with anything, but from all
the config testing werner has done, it really looks like that's the
smoking gun here.

Why does M686 work, but X86_ELAN causes odd problems in 2.6.39-rc?
Allocator issues? Maybe related to the lockless slub paths?

So I obviously agree that X86_ELAN is a crazy choice for a generic
kernel, but it _used_ to work, and this is a regression.

                       Linus

--20cf3079ba82b8f48704a260b783
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gn8yqkis2

IGZzL2xvZ2ZzL3N1cGVyLmMgfCAgICA4ICsrKystLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9sb2dmcy9zdXBlci5j
IGIvZnMvbG9nZnMvc3VwZXIuYwppbmRleCAzMzQzNWU0YjE0ZDIuLmNlMDNhMTgyYzc3MSAxMDA2
NDQKLS0tIGEvZnMvbG9nZnMvc3VwZXIuYworKysgYi9mcy9sb2dmcy9zdXBlci5jCkBAIC00ODAs
MTAgKzQ4MCw2IEBAIHN0YXRpYyBpbnQgbG9nZnNfcmVhZF9zYihzdHJ1Y3Qgc3VwZXJfYmxvY2sg
KnNiLCBpbnQgcmVhZF9vbmx5KQogCQkJIXJlYWRfb25seSkKIAkJcmV0dXJuIC1FSU87CiAKLQlt
dXRleF9pbml0KCZzdXBlci0+c19kaXJvcF9tdXRleCk7Ci0JbXV0ZXhfaW5pdCgmc3VwZXItPnNf
b2JqZWN0X2FsaWFzX211dGV4KTsKLQlJTklUX0xJU1RfSEVBRCgmc3VwZXItPnNfZnJlZWluZ19s
aXN0KTsKLQogCXJldCA9IGxvZ2ZzX2luaXRfcncoc2IpOwogCWlmIChyZXQpCiAJCXJldHVybiBy
ZXQ7CkBAIC02MDEsNiArNTk3LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgZGVudHJ5ICpsb2dmc19tb3Vu
dChzdHJ1Y3QgZmlsZV9zeXN0ZW1fdHlwZSAqdHlwZSwgaW50IGZsYWdzLAogCWlmICghc3VwZXIp
CiAJCXJldHVybiBFUlJfUFRSKC1FTk9NRU0pOwogCisJbXV0ZXhfaW5pdCgmc3VwZXItPnNfZGly
b3BfbXV0ZXgpOworCW11dGV4X2luaXQoJnN1cGVyLT5zX29iamVjdF9hbGlhc19tdXRleCk7CisJ
SU5JVF9MSVNUX0hFQUQoJnN1cGVyLT5zX2ZyZWVpbmdfbGlzdCk7CisKIAlpZiAoIWRldm5hbWUp
CiAJCWVyciA9IGxvZ2ZzX2dldF9zYl9iZGV2KHN1cGVyLCB0eXBlLCBkZXZuYW1lKTsKIAllbHNl
IGlmIChzdHJuY21wKGRldm5hbWUsICJtdGQiLCAzKSkK
--20cf3079ba82b8f48704a260b783--
