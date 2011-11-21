Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1KUEU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:20:27 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:33158 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782Ab1KUEUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:20:25 -0500
Message-ID: <4EC9D175.2070008@st.com>
Date: Mon, 21 Nov 2011 09:50:05 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 5/5] gpio/gpio-stmpe: ADD support for stmpe variant
 801
References: <cover.1321507421.git.viresh.kumar@st.com> <d2b66ba1a6c2b34f7e0b82e31bc360684c734759.1321507421.git.viresh.kumar@st.com> <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com>
In-Reply-To: <CAH+eYFCLauXusdDs75qm2rGB5Y0==bhTbxPJD+gyaaZQVbvsVw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 5:29 PM, Rabin Vincent wrote:
> On Thu, Nov 17, 2011 at 11:02, Viresh Kumar <viresh.kumar@st.com> wrote:
>> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
>> index 4c980b5..000b019 100644
>> --- a/drivers/gpio/gpio-stmpe.c
>> +++ b/drivers/gpio/gpio-stmpe.c
>> @@ -65,7 +65,15 @@ static void stmpe_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
>> +       if (!val && (stmpe->regs[STMPE_IDX_GPSR_LSB] ==
>> +                               stmpe->regs[STMPE_IDX_GPCR_LSB]))
>> +               stmpe_set_bits(stmpe, reg, mask, ~mask);
>> +       else
>> +               stmpe_set_bits(stmpe, reg, mask, mask);
>>  }
> 
> This code,
> 
>  (1) for 801, when clearing one GPIO, sets all the others.

I assumed stmpe_set_bits will only affect bits which are 1
in mask and i was wrong. :(

>  (2) for other devices, adds an an unnecessary read (within stmpe_set_bits()),
>      which wasn't there before.
> 

Correct.

> Please rework to something like:
> 
> 	if (stmpe->regs[...)
> 		stmpe_set_bits(stmpe, reg, mask, val ? mask : 0);
> 	else
> 		stmpe_reg_write(stmpe, reg, mask);
> 

Sure.

>>
>>  static int stmpe_gpio_direction_output(struct gpio_chip *chip,
>> @@ -125,10 +133,19 @@ static struct gpio_chip template_chip = {
>>  static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
>>  {
>>        struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
>> +       struct stmpe *stmpe = stmpe_gpio->stmpe;
>>        int offset = d->irq - stmpe_gpio->irq_base;
>>        int regoffset = offset / 8;
>>        int mask = 1 << (offset % 8);
>>
>> +       /* STMPE801 doesn't have RE and FE registers */
>> +       if (stmpe->partnum == STMPE801) {
>> +               if (type == IRQ_TYPE_LEVEL_LOW || type == IRQ_TYPE_LEVEL_HIGH)
>> +                       return 0;
> 
> This looks wrong.  From the datasheet I see that it supports edges only,
> so perhaps you meant to say IRQ_TYPE_EDGE_* above.
> 

I meant to say IRQ_TYPE_LEVEL* only, but i was wrong. I didn't read the manual
correctly. :(

> In that case please reorganize this to add the return 0 after the
> existing check which excludes levels (below).
> 

Sure

-- 
viresh
