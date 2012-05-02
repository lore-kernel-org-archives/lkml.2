Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2EBFTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:19:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45510 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2EBFTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4BZAf_i3ojXpg5WSFJ00G5i_vscVTu2va_Z3WJ0UHg=g@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-18-git-send-email-yinghai@kernel.org>
	<CAErSpo4BZAf_i3ojXpg5WSFJ00G5i_vscVTu2va_Z3WJ0UHg=g@mail.gmail.com>
Date: Tue, 1 May 2012 22:19:01 -0700
X-Google-Sender-Auth: PJlGmYFVwOdwklSrANmxtaPs6s0
Message-ID: <CAE9FiQURuG9z655PZgP-QR3w7LoSFondt4fhioO0whP=Q7+2rA@mail.gmail.com>
Subject: Re: [PATCH -v11 17/30] resources: Add probe_resource()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 4:57 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Mar 18, 2012 at 11:42 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> It is changed from busn_res only version, because Bjorn found that version
>> was not holding resource_lock.
>> Even it may be ok for busn_res not holding resource_lock.
>> It would be better to have it to be generic and use lock and we would
>> use it for other resources.
>>
>> probe_resource() will try to find specified size or more in parent bus.
>> If can not find current parent resource, and it will try to expand parents
>> top.
>> If still can not find that specified on top, it will try to reduce target size
>> until find one.
>>
>> It will return 0, if it find any resource that it could use.
>>
>> Returned resource already register in the tree.
>>
>> So caller may still need call resource_replace to put real resource in
>> the tree.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  include/linux/ioport.h |    7 ++
>>  kernel/resource.c      |  160 ++++++++++++++++++++++++++++++++++++++++++++++--
>>  2 files changed, 162 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
>> index e885ba2..20a30df 100644
>> --- a/include/linux/ioport.h
>> +++ b/include/linux/ioport.h
>> @@ -156,6 +156,13 @@ extern int allocate_resource(struct resource *root, struct resource *new,
>>                                                       resource_size_t,
>>                                                       resource_size_t),
>>                             void *alignf_data);
>> +void resource_shrink_parents_top(struct resource *b_res,
>> +                                long size, struct resource *parent_res);
>> +struct device;
>> +int probe_resource(struct resource *b_res,
>> +                       struct device *dev, struct resource *busn_res,
>> +                       resource_size_t needed_size, struct resource **p,
>> +                       int skip_nr, int limit, char *name);
>
> This interface is a mess.  I have a vague impression that this is
> supposed to figure out whether a resource can be expanded, but why
> does it need a struct device *?  (I can read the code and see how you
> use it, but it just doesn't fit in the resource abstraction.)

for debug printing purpose.

> Supplying one struct resource * makes sense, but you have three.  A
> char * name?  What's skip_nr?  This just doesn't make sense to me.

name is for debug purpose too.

skip_nr is for skipping.

for example: parent [60-7e]

when we try to probe for child buses, we need skip 60 as it is used already for
pci devices.


>
> I think you need a simpler, more general interface.  update_resource()
> seems OK to me -- it's pretty straightforward and has an obvious
> meaning.  Maybe you can make a resource_expand() or something that
> just expands a resource in both directions as far as possible (until
> it hits a sibling or the parent limits).  Then you would know the
> maximum possible size, and you could use update_resource() to shrink
> it again and give up anything you don't need.

both directions may need more code.

>
> I spent most of the day merging the patches up to this point, and they
> mostly make sense, but this one and the following ones are beyond my
> ken, so I gave up.

ok, let me check if i could simplify that code more.

Thanks

Yinghai
