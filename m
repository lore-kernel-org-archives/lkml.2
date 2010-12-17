Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0LQNRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:17:34 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51314 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0LQNQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:16:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=QLCN9nHHlY3Qcn+6SZrMfVNM8yWJo9U//XbRAK/3GVgPMTut/64dzOWaZ+IcPPFmdZ
         pkQhhoC+OG9e+w371ol+vE/8xr1V5EgfhHbtDZHYI9Hj3pwmYLL3N+Zl2iupNewo8lB6
         CJIZWgyKXKOg2MlNZ8VpwuW2tKHdVavUS9jq0=
MIME-Version: 1.0
In-Reply-To: <20101217130426.GA21706@isilmar-3.linta.de>
References: <1292573592-3624-1-git-send-email-marek.belisko@open-nandra.com>
	<1292573592-3624-2-git-send-email-marek.belisko@open-nandra.com>
	<20101217130426.GA21706@isilmar-3.linta.de>
Date: Fri, 17 Dec 2010 14:16:44 +0100
Message-ID: <AANLkTimivmbhJed8_x_MGWem-3p2EBHj7H--qUy+oSQP@mail.gmail.com>
Subject: Re: [PATCH 1/2] staging: ft1000-pcmcia: Fix compilation errors.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        chl.pixo@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 17, 2010 at 2:04 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> Hey,
>
> On Fri, Dec 17, 2010 at 09:13:11AM +0100, Marek Belisko wrote:
>> Following patch will fix all compilation errors. Main problems
>> was with pcmcia API changes. Also remove BROKEN as now driver
>> is properly build.
>
> Thanks!
>
> One question, though:
>
>> +int ft1000_get_mac(struct pcmcia_device *p_dev, tuple_t *tuple, void *priv)
>>  {
>> -     tuple_t tuple;
>> +     int i;
>>       cisparse_t parse;
>> -     int last_fn, last_ret, i;
>> -     u_char buf[64];
>>       cistpl_lan_node_id_t *node_id;
>> -     cistpl_cftable_entry_t dflt = { 0 };
>> -     cistpl_cftable_entry_t *cfg;
>> -     unsigned char mac_address[6];
>> -
>> -     DEBUG(0, "ft1000_cs: ft1000_config(0x%p)\n", link);
>>
>> +     if (!pcmcia_parse_tuple(tuple, &parse)) {
>> +             if (parse.funce.type == CISTPL_FUNCE_LAN_NODE_ID) {
>> +                     node_id = (cistpl_lan_node_id_t *) parse.funce.data;
>> +                     if (node_id->nb == 6) {
>> +                             for (i = 0; i < 6; i++)
>> +                                     *((unsigned char *)priv + i) =
>> +                                             node_id->id[i];
>> +                             /*
>> +                              *  we found MAC address and will
>> +                              * end the pcmcia_loop_tuple
>> +                              */
>> +                             return 0;
>> +                     }
>> +             }
>> +     }
>>       /*
>> -        This reads the card's CONFIG tuple to find its configuration
>> -        registers.
>> +      * we did not find MAC address in this tuple
>> +      * continue pcmcia_loop_tuple
>>        */
>> -//   tuple.DesiredTuple = CISTPL_CONFIG;
>> -//   tuple.Attributes = 0;
>> -     tuple.TupleData = buf;
>> -     tuple.TupleDataMax = sizeof(buf);
>> -     tuple.TupleOffset = 0;
>> -//   CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(link, &tuple));
>> -//   CS_CHECK(GetTupleData, pcmcia_get_tuple_data(link, &tuple));
>> -//   CS_CHECK(ParseTuple, pcmcia_parse_tuple(link, &tuple, &parse));
>> -//   link->conf.ConfigBase = parse.config.base;
>> -//   link->conf.Present = parse.config.rmask[0];
>> +     return 1;
>> +}                               /* ft1000_get_mac */
>
> ...
>
>> +     /* get the MAC address */
>> +     ret = pcmcia_loop_tuple(link, CISTPL_FUNCE,
>> +                             ft1000_get_mac, mac_address);
>> +     if (ret)
>> +             goto failed;
>
> Does this differ from the generic pcmcia_get_mac_from_cis() function, or
> could we use this generic function for the purposes needed in this driver?
Thanks for reviewing. We miss such a helper function.  After checking
it do the same think.
@Greg: should resend or will send in next patch?
>
> Best,
>        Dominik
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
