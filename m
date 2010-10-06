Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0JFWSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:18:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51236 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0JFWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mesMcCX6oE7ewdh42KhzzX3chWOok8cgVKnIVbFkqtagI4wnn0h0eyrHNWFLZUmErs
         ugLoqkEpkoGeUMvMnpcKUgBi8aWKODVkn1vGBB6PDfg41ppEY+mkrdddZIu19xnGCbsj
         tsP9ZN5267tDcv9NVN1tcWBJJi76Ly/iI1OpA=
Message-ID: <4CACF5A7.3010601@gmail.com>
Date: Thu, 07 Oct 2010 00:18:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com> <1286381895-11329-2-git-send-email-pavan_savoy@ti.com> <4CACD234.7020900@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 10:08 PM, Savoy, Pavan wrote:
>> On 10/06/2010 06:18 PM, pavan_savoy@ti.com wrote:
>>> --- /dev/null
>>> +++ b/drivers/misc/ti-st/st_core.c
>>> @@ -0,0 +1,1031 @@
>> ...
>>> +#define PROTO_ENTRY(type, name)	name
>>> +const unsigned char *protocol_strngs[] = {
>>> +	PROTO_ENTRY(ST_BT, "Bluetooth"),
>>> +	PROTO_ENTRY(ST_FM, "FM"),
>>> +	PROTO_ENTRY(ST_GPS, "GPS"),
>>> +};
>>
>> Is this planned to be used somewhere?
> 
> Yes- would go in the debugfs.
> Doesn't it already? Will check up, & will remove if not required.

The thing probably is that you have protocol_strngs here and
protocol_names there.

>>> +		pr_err("protocol %d not registered, no data to send?",
>>> +			   protoid);
>>
>> Missing \n. And all over the code.
> 
> With pr_fmt defined in each source file, the "\n" is not necessary.
> I don't see the logs getting all jumbled up in one line.
> 
> However If I don't have a pr_fmt, I see the need for "\n" - Please suggest.

I can't explain that, but I see no reason why you wouldn't need \n
there. It expands to standard printk(KERN_ERR "(stc): " fmt) where fmt
should contain \n. I remember Linus sending a patch to the list which
added \n by default if <.> is about to be printed next. But I don't know
if he pushed it out. You can check printk implementation.

>>> +static inline int st_check_data_len(struct st_data_s *st_gdata,
>>
>> It doesn't look like a candidate for inlining.
> 
> Because?

Because it does too much to be an inline. The compiler will inline that
itself on its own if it decides to. It can count the pros and cons more
precisely than we can. Also note that gcc will un-inline that if it
decides to (if the inlining penalty is too high).

>>> +int st_core_init(struct st_data_s **core_data)
>>> +{
>>> +	struct st_data_s *st_gdata;
>>> +	long err;
>>> +	static struct tty_ldisc_ops *st_ldisc_ops;
>>> +
>>> +	/* populate and register to TTY line discipline */
>>> +	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
>>> +	if (!st_ldisc_ops) {
>>> +		pr_err("no mem to allocate");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	st_ldisc_ops->magic = TTY_LDISC_MAGIC;
>>> +	st_ldisc_ops->name = "n_st";	/*"n_hci"; */
>>> +	st_ldisc_ops->open = st_tty_open;
>>> +	st_ldisc_ops->close = st_tty_close;
>>> +	st_ldisc_ops->receive_buf = st_tty_receive;
>>> +	st_ldisc_ops->write_wakeup = st_tty_wakeup;
>>> +	st_ldisc_ops->flush_buffer = st_tty_flush_buffer;
>>> +	st_ldisc_ops->owner = THIS_MODULE;
>>
>> This can be static structure, you don't need to allocate this on heap.
>> It should be a singleton.
> 
> Yes, I got this comment before, but is it just a style issue?
> I want to keep this in heap because some day, I hope TTY ldics have their own
> private_data, which I can pass around like the tty_struct's data.
> and having them in heap, I plan to keep a reference to ops structure, so that I
> can pass around and use ops->private_data everywhere ..

I doubt ldisc ops will ever have ->private_data. What would you need it
for? The ops generally work with ttys which have ->disc_data.

>>> +void kim_int_recv(struct kim_data_s *kim_gdata,
>>> +	const unsigned char *data, long count)
>>> +{
>>> +	register char *ptr;
>>> +	struct hci_event_hdr *eh;
>>> +	register int len = 0, type = 0;
>>
>> registers
>>
>>> +	pr_debug("%s", __func__);
>>
>> \n
>>
>>> +	/* Decode received bytes here */
>>> +	ptr = (char *)data;
>>
>> Casting from const to non-const. It doesn't look correct.
> 
> So, would I rather declare ptr as const?

Yes, if that makes sense. Otherwise de-const data.

>>> +long st_kim_start(void *kim_data)
>>> +{
>>> +	long err = 0;
>>> +	long retry = POR_RETRY_COUNT;
>>> +	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
>>> +
>>> +	pr_info(" %s", __func__);
>>> +
>>> +	do {
>>> +		/* TODO: this is only because rfkill sub-system
>>> +		 * doesn't send events to user-space if the state
>>> +		 * isn't changed
>>> +		 */
>>> +		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
>>> +		/* Configure BT nShutdown to HIGH state */
>>> +		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
>>> +		mdelay(5);	/* FIXME: a proper toggle */
>>> +		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
>>> +		mdelay(100);
>>
>> You can sleep here instead (below you wait for completion). 100 ms of
>> busy waiting is way too much.
> 
> It's agreed upon from the process, since it is in a process context.
> Like's a device's open or hci0's UP.

Dunno if you got me right. I meant mdelay->msleep.

regards,
-- 
js
