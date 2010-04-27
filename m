Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0D0LxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:53:19 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40210 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0D0LxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LquK/pUcbTUDZYV4hTKXWSY3dHpev1eNuiA8sBJRegTw5UGtSiTUZDZujUhRbXT6Cy
         bV7l529CYONaDjP2JF3PhnPUpXv7fdJqcRcJW6AUOQZBHLo4bVtKN57s4Ojv1u4KsDyc
         XmVFWCl3NZ1yR+wOSTaLW+pa/qOi7cvkJTepI=
MIME-Version: 1.0
In-Reply-To: <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
References: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
	 <20100419145934.GA10893@kroah.com>
	 <t2w1ba2fa241004211522le49fc938m341553b0f2b89031@mail.gmail.com>
	 <20100425163711.GA20196@kroah.com>
	 <o2n1ba2fa241004251222x6ab49726p9757fd8be4952bee@mail.gmail.com>
	 <20100425193658.GA24039@kroah.com>
	 <m2g1ba2fa241004251309oa5592255lb4e4b96ea07dd12a@mail.gmail.com>
	 <o2qac3eb2511004260338xd8146a7dy415d3f0f4f1c8bbc@mail.gmail.com>
	 <1272295140.2434.8.camel@yio.site>
	 <j2t1ba2fa241004270418hd37b1fdk83f31d4f608584f9@mail.gmail.com>
Date: Tue, 27 Apr 2010 14:53:07 +0300
Message-ID: <z2s1ba2fa241004270453u38bd88cbs40e818ebc9a39a65@mail.gmail.com>
Subject: Re: request_firmware API exhaust memory
From: Tomas Winkler <tomasw@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 2:18 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Apr 26, 2010 at 6:19 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Mon, 2010-04-26 at 12:38 +0200, Kay Sievers wrote:
>>> On Sun, Apr 25, 2010 at 22:09, Tomas Winkler <tomasw@gmail.com> wrote:
>>> > Said thing is that I don't see where the memory goes.... Anyhow I will
>>> > try to run valgrin on udev just to be sure.
>>>
>>> Nah, that memory would be freed, if you kill all udev processes, which
>>> it doesn't.
>>>
>>> The many udev worker processes you see for a few seconds was caused by
>>> udevd handling events with TIMEOUT= set special. We need to make sure,
>>> that firmware events run immediately and don't wait for other
>>> processes to finish. The logic who does that was always creating a new
>>> worker. I changed this now, but this will not affect the underlying
>>> problem you are seeing, it will just make the udev workers not grow in
>>> a timeframe of less than 10 seconds. The change is here:
>>>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commit;h=665ee17def2caa6811ae032ae68ebf8239a18cf8
>>> but as mentioned, this change is unrelated to the memory leak you are seeing.
>>>
>>> > I'll be glad If someone can run my simple driver I posted and confirm
>>> > that sees the same problem
>>>
>>> I can confirm that memory gets lost. I suspect for some reason the
>>> firmware does not get properly cleaned up. If you increase the size of
>>> the firmware image, it will leak memory much faster.
>>
>> I guess, the assumption that vfree() will free pages which are allocated
>> by custom code, and not by vmalloc(), is not true.
>>
>> The attached changes seem to fix the issue for me.
>>
>> The custom page array mangling was introduced by David as an optimization
>> with commit 6e03a201bbe8137487f340d26aa662110e324b20 and this should be
>> checked, and if needed be fixed.
>>
>> Cheers,
>> Kay
>>
>>
>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> index 985da11..fe4e872 100644
>> --- a/drivers/base/firmware_class.c
>> +++ b/drivers/base/firmware_class.c
>> @@ -162,7 +162,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>>                        mutex_unlock(&fw_lock);
>>                        break;
>>                }
>> -               vfree(fw_priv->fw->data);
>> +               vunmap(fw_priv->fw->data);
>>                fw_priv->fw->data = NULL;
>>                for (i = 0; i < fw_priv->nr_pages; i++)
>>                        __free_page(fw_priv->pages[i]);
>> @@ -176,7 +176,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>>                break;
>>        case 0:
>>                if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
>> -                       vfree(fw_priv->fw->data);
>> +                       vunmap(fw_priv->fw->data);
>>                        fw_priv->fw->data = vmap(fw_priv->pages,
>>                                                 fw_priv->nr_pages,
>>                                                 0, PAGE_KERNEL_RO);
>> @@ -184,9 +184,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>>                                dev_err(dev, "%s: vmap() failed\n", __func__);
>>                                goto err;
>>                        }
>> -                       /* Pages will be freed by vfree() */
>> -                       fw_priv->page_array_size = 0;
>> -                       fw_priv->nr_pages = 0;
>>                        complete(&fw_priv->completion);
>>                        clear_bit(FW_STATUS_LOADING, &fw_priv->status);
>>                        break;
>> @@ -578,7 +575,7 @@ release_firmware(const struct firmware *fw)
>>                        if (fw->data == builtin->data)
>>                                goto free_fw;
>>                }
>> -               vfree(fw->data);
>> +               vunmap(fw->data);
>>        free_fw:
>>                kfree(fw);
>>        }
>>
>
> The difference between vfree and vunmap is that vfree request for
> deallocating the pages while vunmap leaves the  pages allocated. I
> don't think you can replace vfree with vunmap the way you did.
> The transition from vmalloc to alloc_pages were done by the patch
> bellow.  I think this needs some more review.
>
> commit 6e03a201bbe8137487f340d26aa662110e324b20
> Author: David Woodhouse <dwmw2@infradead.org>
> Date:   Thu Apr 9 22:04:07 2009 -0700
>
>    firmware: speed up request_firmware(), v3
>
>    Rather than calling vmalloc() repeatedly to grow the firmware image as
>    we receive data from userspace, just allocate and fill individual pages.
>    Then vmap() the whole lot in one go when we're done.
>
>    A quick test with a 337KiB iwlagn firmware shows the time taken for
>    request_firmware() going from ~32ms to ~5ms after I apply this patch.
>
>    [v2: define PAGE_KERNEL_RO as PAGE_KERNEL where necessary, use min_t()]
>    [v3: kunmap() takes the struct page *, not the virtual address]
>
>    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>    Tested-by: Sachin Sant <sachinp@in.ibm.com


It looks like to me that  fw_realloc_buffer missing some 'vREmap' code

Tomas
