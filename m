Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934555Ab1EST4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:56:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:49462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934153Ab1EST4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:56:42 -0400
Message-ID: <4DD575EF.2060008@suse.de>
Date: Thu, 19 May 2011 15:56:31 -0400
From: Jeff Mahoney <jeffm@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Tim Bird <tim.bird@am.sony.com>, Christoph Hellwig <hch@infradead.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: module boot time (was Re: [PATCH] module: Use binary search in
 lookup_symbol())
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <20110517232241.GA19140@kroah.com> <4DD305B3.3000707@am.sony.com> <20110518075428.GA29998@infradead.org> <4DD3FB1C.3040103@am.sony.com> <20110518192110.GB26945@kroah.com> <4DD435B7.9090702@am.sony.com> <20110518213451.GA23702@kroah.com>
In-Reply-To: <20110518213451.GA23702@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/18/2011 05:34 PM, Greg KH wrote:
> On Wed, May 18, 2011 at 02:10:15PM -0700, Tim Bird wrote:
>>>>> And why do people overly care for the load time?
>>>>
>>>> To reduce overall boot time.
>>>
>>> To reduce it even more, build the modules into the kernel :)
>>
>> That's what I do most of the time.  For some projects,
>> it is useful to build certain things as modules so you can
>> defer initializing them until later in the boot sequence.
>> You can get some critical user-space tasks running, then
>> come back later to initialize USB and other drivers.
>> On cameras, it's not uncommon to want to get to user
>> space in the first 500 milliseconds.
> 
> That's common even on desktops and servers, and using the bootchart code
> in the kernel helps find those bottlenecks.
> 
>> Sony has some code which allows us to both statically link
>> drivers and defer their initialization, but it's kind of
>> kludgy and requires modifying the module declarations
>> for the code you want to defer.  Let me know if you think
>> this is worth doing an RFC about.
> 
> I don't think that's worth it, there has been talk, and some initial
> code, about adding kernel modules to the kernel image itself, which
> would solve a lot of the i/o time of loading modules, and solves some
> other boot speed problems.  That work was done by Jeff Mahoney, but I
> think he ran into some "interesting" linker issues and had to shelve it
> due to a lack of time :(

I had a few attempts at this before I had to move on to other things. I
haven't gotten a chance to take another look.

I had two approaches:

1) Statically link in modules post-build. This actually worked but had
some large caveats. The first was that an un-relocated image (vmlinux.o)
was needed in order to make it work and a ~ 200 MB footprint to gain a
fairly small win in boot time didn't seem like a good tradeoff. The
other issue was more important and is what made me abandon this
approach: If the entire image is re-linked then the debuginfo package
that we as a distributor offer but don't typically install becomes
invalid. Our support teams would not be too thrilled with the idea of
crash dumps that can't be used.

2) Build a "megamodule" that is loaded like an initramfs but is already
internally linked and requires no additional userspace. I got the
megamodule creation working but didn't get the loading aspect of it done
yet.

In both cases, I added the regular initcall sections to the modules in
addition to the module sections so they'd be loaded in the order they
would have been if they were actually statically linked.

I hadn't thought about it until now and it may not actually work, but it
could be possible to use the megamodule approach *and* link it into a
static vmlinux image as an appended section that's optionally used.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3Vde8ACgkQLPWxlyuTD7LxPgCeIuBHX+KnedsMzBz3H8JrwsGG
etgAn0J5tEwjnTFuIWFLdhzR9QHpSmq5
=Jtc/
-----END PGP SIGNATURE-----
