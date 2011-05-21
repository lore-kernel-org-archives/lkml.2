Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1EUOX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 10:23:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab1EUOX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 10:23:57 -0400
Message-ID: <4DD7CAF6.1000501@suse.de>
Date: Sat, 21 May 2011 10:23:50 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: module boot time (was Re: [PATCH] module: Use binary search in
 lookup_symbol())
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <20110517232241.GA19140@kroah.com> <4DD305B3.3000707@am.sony.com> <20110518075428.GA29998@infradead.org> <4DD3FB1C.3040103@am.sony.com> <20110518192110.GB26945@kroah.com> <4DD435B7.9090702@am.sony.com> <20110518213451.GA23702@kroah.com> <4DD575EF.2060008@suse.de> <4DD6DD39.2090302@am.sony.com>
In-Reply-To: <4DD6DD39.2090302@am.sony.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/20/2011 05:29 PM, Tim Bird wrote:
> On 05/19/2011 12:56 PM, Jeff Mahoney wrote:
>> On 05/18/2011 05:34 PM, Greg KH wrote:
>>> I don't think that's worth it, there has been talk, and some initial
>>> code, about adding kernel modules to the kernel image itself, which
>>> would solve a lot of the i/o time of loading modules, and solves some
>>> other boot speed problems.  That work was done by Jeff Mahoney, but I
>>> think he ran into some "interesting" linker issues and had to shelve it
>>> due to a lack of time :(
>>
>> I had a few attempts at this before I had to move on to other things. I
>> haven't gotten a chance to take another look.
>>
>> I had two approaches:
>>
>> 1) Statically link in modules post-build. This actually worked but had
>> some large caveats. The first was that an un-relocated image (vmlinux.o)
>> was needed in order to make it work and a ~ 200 MB footprint to gain a
>> fairly small win in boot time didn't seem like a good tradeoff. The
>> other issue was more important and is what made me abandon this
>> approach: If the entire image is re-linked then the debuginfo package
>> that we as a distributor offer but don't typically install becomes
>> invalid. Our support teams would not be too thrilled with the idea of
>> crash dumps that can't be used.
>>
>> 2) Build a "megamodule" that is loaded like an initramfs but is already
>> internally linked and requires no additional userspace. I got the
>> megamodule creation working but didn't get the loading aspect of it done
>> yet.
>>
>> In both cases, I added the regular initcall sections to the modules in
>> addition to the module sections so they'd be loaded in the order they
>> would have been if they were actually statically linked.
>>
>> I hadn't thought about it until now and it may not actually work, but it
>> could be possible to use the megamodule approach *and* link it into a
>> static vmlinux image as an appended section that's optionally used.
> 
> 
> What was the use case for this?   My use case is that I want
> to use all the modules compiled into the kernel, but I don't
> want to run some modules' initcalls until well after kernel
> and user-space startup.
> 
> My solution is very simple - create a new initcall macro for
> the initcalls I want to defer, along with a new 'deferred' initcall
> section where the function entries can be accumulated.  Then,
> I avoid freeing init memory at standard initcall time.  Once
> the main user-space has initialized, it echos to a /proc file
> to cause the deferred initcalls to be called, and the init memory
> to be freed.
> 
> I'm attaching the patch below, because it's short enough to
> see what's going on without a lot of digging.
> 
> This method eliminates the linking cost for module loading,
> saves the memory overhead of the ELF module format, and gives
> me control over when the deferred modules will be initialized.
> The big downside is that you have to manually change the definition
> for the initcall from 'module_init' to 'deferred_module_init'
> for the modules you want to defer.  Maybe there's a simple way
> to control this with a kernel config? That would make this a pretty
> nice, generic, system for deferring module initialization, IMHO.
> 
> If your use case is that you want all the modules present, but
> want to initialize only some of them later, then maybe a list of
> module names could be passed into the /proc interface, and the
> routine could selectively initialize the deferred modules.

Yep, it seems like we were going after different use cases. Mine was to
eliminate the initramfs except where userspace portions of it are needed.

We improved the boot time of the openSUSE kernel by statically linking
the most popular drivers into the kernel. I'm not a fan of that approach
for a generic distribution kernel but you can't argue with the numbers.
In the ideal case, the initcalls would happen in the same order they
would if they were statically linked in. Wed get the boot speed of a
static kernel with the flexibility advantages of shipping modules.

Your approach might ultimately dovetail nicely into that but since I
didn't have the time to get something functional, I don't have numbers
of my own.

- -Jeff

- -- 
Jeff Mahoney
SuSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3XyvYACgkQLPWxlyuTD7LlYwCgmQv86e0lxu6e5mfvwcevAIDb
7nwAn1jb6694mQ+vkcVD0bDsrKvQXOV1
=Q5xL
-----END PGP SIGNATURE-----
