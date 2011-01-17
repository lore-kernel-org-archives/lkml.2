Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1AQX1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:27:10 -0500
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:48673 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab1AQX1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:27:09 -0500
Message-ID: <4D34D046.20708@home.nl>
Date: Tue, 18 Jan 2011 00:27:02 +0100
From: Walter Goossens <waltergoossens@home.nl>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Thomas Chou <thomas@wytron.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        linux-input@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] alter_ps2: Add devicetree support
References: <4D040D1C.2020705@home.nl> <1295245760-4566-1-git-send-email-thomas@wytron.com.tw> <AANLkTi=8+Q5dm+5Pa-cYkmaBWQ4S7jgjZOL0ovtmrdxB@mail.gmail.com> <4D34AEC3.60801@home.nl> <20110117220244.GA17963@angua.secretlab.ca>
In-Reply-To: <20110117220244.GA17963@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1PeyTY-0007ef-IO
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=1.717, vereist 5, ALL_TRUSTED -1.00, BAYES_40 -0.00,
	HELO_LH_HOME 1.74, RDNS_DYNAMIC 0.98)
X-ZiggoSMTP-MailScanner-SpamScore: s
X-ZiggoSMTP-MailScanner-From: waltergoossens@home.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/11 11:02 PM, Grant Likely wrote:
> On Mon, Jan 17, 2011 at 10:04:03PM +0100, Walter Goossens wrote:
>> On 1/17/11 7:59 AM, Grant Likely wrote:
>>> On Sun, Jan 16, 2011 at 11:29 PM, Thomas Chou<thomas@wytron.com.tw>  wrote:
>>>> @@ -173,6 +176,16 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>>>>         return 0;
>>>>   }
>>>>
>>>> +#ifdef CONFIG_OF
>>>> +static struct of_device_id altera_ps2_match[] = {
>>>> +       {
>>>> +               .compatible = "altera,altera_ps2",
>>>> +       },
>>> So is this an FPGA soft core PS2 device?  Is there any kind of version
>>> attached to the soft core?  The compatible value should specify an
>>> exact version of the implementation that this driver works with.
>>> (Newer core versions can claim compatibility with older ones, so the
>>> driver's compatible list doesn't need to be exhaustive).
>>>
>> What's the preferred way of versioning components in a device-tree?
>> Quite a few components inside an fpga will get a new version number with
>> every release of the tools. For example components supplied by Altera
>> will get a new number with every release of their IP library (approx.
>> twice a year) even when (at least from a software point of view) there
>> is nothing changed in the core. Should we add the number to the
>> "compatible" name and possibly get slightly more bulky drivers, or add a
>> version tag to the components where a driver can make decisions based on
>> the version of the core (if needed)?
>> Another way to reduce the number of lines in a compatible section would
>> be to add both their versioned and unversioned compatible entry in the
>> dts so drivers not needing a specific version don't need to supply the
>> entire list.
>> We do have the version numbers available when generating the DTS and
>> NiosII is still quite new to device-tree so we are still flexible in
>> fixing this in the best possible way.
> A good rule of thumb is to always choose compatible values that
> reflect real working hardware.  ie. "xlnx,xps-uartlite-1.00.a" instead
> of trying to define a generic "xlnx,uartlite".  You can see this value
> in drivers/serial/uartlite.c, and write the driver to match the value
> of the device that you actually worked with.
>
> Then, when you produce a .dts for a design, each device must specify
> exactly what it is (the specific version) plus an optional list of
> devices that it is 100% register-level backwards compatible with.  In
> the example above, the uartlite has retained the exact same interface,
> so all designs claim compatibility with xlnx,xps-uartlite-1.00.a
> regardless of the actual version.
>
> To take the example of the altera ps2 core; say altera has released
> versions 1, 2, 3, 4 and 5 of the core, and say the behaviour changed
> in a non-compatible way in version 3.  Then the driver might do
> something like:
>
>
> static struct of_device_id altera_ps2_match[] = {
>         { .compatible = "altera,altera_ps2-1", .data = altera_ps2_1_ops, },
>         { .compatible = "altera,altera_ps2-3", .data = altera_ps2_3_ops, },
>         { }
> };
>
> Then the compatible values for each version in a .dts file would be:
>
> v1: compatible = "altera,altera_ps2-1";
> v2: compatible = "altera,altera_ps2-2", "altera,altera_ps2-1";
> v3: compatible = "altera,altera_ps2-3";
> v4: compatible = "altera,altera_ps2-4", "altera,altera_ps2-3";
> v5: compatible = "altera,altera_ps2-5", "altera,altera_ps2-3";
>
> so, instead of trying to us a 'generic' value like "altera,altera_ps2"
> which has a bunch of ambiguity about which hardware actually
> implements the behaviour, the values "altera,altera_ps2-1" and
> "altera,altera_ps2-3" become the de-facto 'generic' values without any
> messiness or ambiguity about what they mean.
>
> Plus, each .dts file still specifies the exact version that is
> implemented on the board so that the driver can still fixup
> version-specific bugs if any are discovered in the future.
>
Ahh ok.
That does look like a good solution. I'll try and cook something up for 
that.
Thanks for the explanation!

Walter

> g.
>
>>> Otherwise, this patch looks correct.
>>>
>>> g.
>>>
>>>> +       {},
>>>> +}
>>>> +MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
>>>> +#endif /* CONFIG_OF */
>>>> +
>>>>   /*
>>>>   * Our device driver structure
>>>>   */
>>>> @@ -182,6 +195,9 @@ static struct platform_driver altera_ps2_driver = {
>>>>         .driver = {
>>>>                 .name   = DRV_NAME,
>>>>                 .owner  = THIS_MODULE,
>>>> +#ifdef CONFIG_OF
>>>> +               .of_match_table = altera_ps2_match,
>>>> +#endif
>>>>         },
>>>>   };
>>>>
>>>> --
>>>> 1.7.3.4
>>>>
>>>>
>>>

