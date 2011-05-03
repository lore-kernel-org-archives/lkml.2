Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1ECOmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:42:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:28929 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1ECOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:42:36 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK9371O1443N1432N98dK14ffOzz1202hzzz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mail10.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-IronPort-AV: E=Sophos;i="4.64,309,1301889600"; 
   d="scan'208";a="33120925"
Message-ID: <4DC01237.4040603@analog.com>
Date: Tue, 3 May 2011 16:33:27 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Barry Song <21cnbao@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lapointe, Yves" <Yves.Lapointe@analog.com>,
        "Flanagan, Adrian" <Adrian.Flanagan@analog.com>,
        "Pratt, Susan" <Susan.Pratt@analog.com>
Subject: Re: ad714x driver help and possible bug
References: <62821D7C-1637-4F7E-A53A-F52AEB2A6C87@gmail.com> <4DBA8AFE.6080807@cam.ac.uk> <A89A87E2-E4C4-4DD7-9E51-9FD38D93DC0E@gmail.com>
In-Reply-To: <A89A87E2-E4C4-4DD7-9E51-9FD38D93DC0E@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 04:13 PM, Jean-Francois Dagenais wrote:
> On Apr 29, 2011, at 5:55, Jonathan Cameron wrote:
>
>   
>> Cc'd input, and analog devices driver list...
>>
>> On 04/28/11 19:17, Jean-Francois Dagenais wrote:
>>     
>>> Hi all,
>>>
>>> I am having trouble getting the ad714x (i2c) driver to work in my
>>> test setup. I am using the VGA i2c bus to talk to the ad7147 I have.
>>> I used INTA of a PCI ethernet slot in my PC. I enabled the PCI device
>>> without the driver module loaded.  I then give the interrupt number
>>> to ad714x through the struct i2c_board_info. I actually tried the
>>> same setup on two PCs, one intel graphics, the other nvidia to
>>> eliminate the i2c master as a possible cause of my problem.
>>>
>>> The device is successfully loaded and I can see the interrupts going.
>>> The eventN device created under /dev/input never spit out anything
>>> and so I added printks in the threaded ISR handler to see what is
>>> going on.
>>>
>>> I only have a wheel with 8 stages. In ad714x_wheel_state_machine() I
>>> see that upon the first interrupt, the state goes from IDLE to
>>> JITTER. After this the JITTER case checks that c_state == mask (with
>>> mask being 0xff in our case). This condition is never met and the
>>> driver stays indefinitely in this state. After lifting my finger from
>>> the wheel, the chip settles down to scanning every so many
>>> milliseconds.
>>>
>>> The STAGE_COMPLETE_INT_STATUS is always 0 when my finger is off, but
>>> varies a lot while my finger is on (while interrupt frequency is
>>> high). Looking at the value of STAGE_COMPLETE_INT_STATUS in binary
>>> reveals that the set bits are always in groups, e.g. 0x0007 or 0x001C
>>> or 0x0081(I imagine a roll-over of our start_stage-end_stage (0-7)).
>>> There seems to be a timing aspect here. I added a spin counter in the
>>> threaded ISR to delay reading the 3 registers and that seemed to make
>>> the c_state change a little.
>>>
>>> I modified the code that reads the 3 registers right after the
>>> mutex_lock in ad714x_interrupt_thread so that the
>>> STAGE_COMPLETE_INT_STATUS is read before the other two (LOW and HIGH
>>> regs). The result was surprising. The COMPLETE reg did read 0xff now
>>> and the JITTER case went past the "if(c_state == mask)" but later
>>> crashed (divide by 0) in ad714x_wheel_cal_abs_pos() called from the
>>> JITTER case.
>>>
>>>
>>> Here's the initial configuration I give the driver:
>>>
>>> static struct ad714x_wheel_plat wheel_platform_data = {
>>>      .start_stage = 0, // int start_stage;
>>>      .end_stage = 7, // int end_stage;
>>>      .max_coord = 128,  // int max_coord;
>>> };
>>>
>>> static struct ad714x_platform_data wheel_dev_platform_data = {
>>>      .slider_num = 0,
>>>      .wheel_num = 1,
>>>      .touchpad_num = 0,
>>>      .button_num = 0,
>>>      .slider = 0,
>>>      .wheel = &wheel_platform_data, // struct ad714x_wheel_plat *wheel;
>>>      .touchpad = 0, // struct ad714x_touchpad_plat *touchpad;
>>>      .button = 0, // struct ad714x_button_plat *button;
>>>      .stage_cfg_reg =  { /* unsigned short stage_cfg_reg[STAGE_NUM][STAGE_CFGREG_NUM] */
>>>              {0xfffe, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xfffb, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xffef, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xffbf, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xfeff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xfbff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xefff, 0x3fff, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>              {0xffff, 0x3ffe, 0, 0x2626, 0x3e8, 0x3e8, 0x1388, 0x1388 },
>>>
>>>              {0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
>>>              {0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
>>>              {0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
>>>              {0xffff, 0x3fff, 0, 0x0606, 0x01f4, 0x01f4, 0x0320, 0x0320},
>>>      },
>>>      .sys_cfg_reg = {0x027e, 0x00ff, 0x3233, 0x0819, 0x0832, 0x0000, 0x00ff, 0}, /* unsigned short sys_cfg_reg[SYS_CFGREG_NUM] */
>>>      //.sys_cfg_reg = {0x2b2, 0xfff, 0x3233, 0x819, 0x832, 0xcff, 0xcff, 0x0}, /* unsigned short sys_cfg_reg[SYS_CFGREG_NUM] */
>>> };
>>>
>>>       
>>     
>>> I also had to change the request_threaded_irq flags to specify
>>> IRQF_ONESHOT so the kernel keeps the interrupt masked while we are
>>> running ad714x_interrupt_thread(). Otherwise we were getting storms
>>> of interrupts each time only one was requested. I am wondering if
>>> this should be pulled back to the mainline kernel?
>>>
>>> Thanks for pointers and clues!
>>>
>>>       
>>     
> here's the printk I added to ad714x_wheel_state_machine()
>
>         mask = ((1 << (hw->end_stage + 1)) - 1) - ((1 << hw->start_stage) - 1);
>
>         h_state = ad714x->h_state & mask;
>         c_state = ad714x->c_state & mask;
>         dev_dbg(ad714x->dev, "interrupt state:%d mask:0x%x l:0x%x h:0x%x c:0x%x\n",
>                 sw->state,
>                 (u32)mask,
>                 (u32)ad714x->l_state,
>                 (u32)ad714x->h_state,
>                 (u32)ad714x->c_state);
>
> Here what it looks like upon loading a module which does the i2c_new_device of the AD7147:
>
> <7>[58302.186886] my-pci-stub 0000:01:04.0: claimed by my platform module PCI stub
> <6>[58302.186903] my-pci-stub 0000:01:04.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> <6>[58302.189815] ad714x_captouch 9-002c: found AD7147(A) captouch, rev:1
> <6>[58302.427237] input: Unspecified device as /devices/virtual/input/input8
>
> [ pause here while my hand goes from my mouse and keyboard to the wheel on the AD7147 ]
>
> <7>[58311.646183] ad714x_captouch 9-002c: interrupt state:0 mask:0xff l:0x0 h:0x18 c:0x1c
> <7>[58311.646192] ad714x_captouch 9-002c: case IDLE in if
> <7>[58311.655436] ad714x_captouch 9-002c: wheel 0 touched
> <7>[58311.663087] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x7
> <7>[58311.674562] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x81
> <7>[58311.686803] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x81
> <7>[58311.699147] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x81
> <7>[58311.711430] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x81
> <7>[58311.723585] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x18 c:0x81
> <7>[58311.736017] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.748298] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.760581] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.772800] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.785176] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.797473] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x81
> <7>[58311.809651] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x10 c:0x81
>
> [ here I lift my finger ]
>
> <7>[58311.822059] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.834345] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.846582] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.858800] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.871212] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.883517] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.895802] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.908099] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.920381] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58311.932585] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
>
> [...]
>
> <7>[58313.432218] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
> <7>[58314.157343] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x81
>
> [... after 2 seconds or so, the rhythm slows down to 2 interrupts per second or so ]
>
> <7>[58314.169629] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x80
>
> <7>[58314.976518] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x80
>
> <7>[58315.783342] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x0 c:0x80
>
>
> There is a clue in what I did next. I added a wait time in the isr thread function like so:
>
> static irqreturn_t ad714x_interrupt_thread(int irq, void *data)
> {
>         struct ad714x_chip *ad714x = data;
>         volatile int i;
>
>         mutex_lock(&ad714x->mutex);
>
>         i=0xffffff;
>         while(i)
>                 --i;
>
>         ad714x->read(ad714x->dev, STG_LOW_INT_STA_REG, &ad714x->l_state);
>         ad714x->read(ad714x->dev, STG_HIGH_INT_STA_REG, &ad714x->h_state);
>         ad714x->read(ad714x->dev, STG_COM_INT_STA_REG, &ad714x->c_state);
> [ ... ]
>
> this changes the above trace to these values:
>
> while touching the wheel:
> <7>[63085.414268] ad714x_captouch 9-002c: interrupt state:0 mask:0xff l:0x0 h:0x70 c:0x60
> <7>[63085.414277] ad714x_captouch 9-002c: case IDLE in if
> <7>[63085.423519] ad714x_captouch 9-002c: wheel 0 touched
> <7>[63085.578931] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x70 c:0x18
> <7>[63085.736079] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x70 c:0x3
> <7>[63085.832304] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x70 c:0x60
> <7>[63086.938334] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x30 c:0x60
> <7>[63087.030835] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x60
> <7>[63087.122909] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x60
> <7>[63087.215014] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x60
> <7>[63087.307071] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x60
> <7>[63087.399367] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x60
> <7>[63087.739386] ad714x_captouch 9-002c: interrupt state:1 mask:0xff l:0x0 h:0x38 c:0x83
>
> Again, notice the state going from 0 (IDLE) to 1(JITTER), and never entering the "if" in the JITTER case (needs mask == c_state).  The HIGH register varies a lot while I move my finger around, but the COMPLETE looks like its always going and being cleared. I mentioned before that reading the COMPLETE status reg before the LOW and HIGH produces completely different results.
>
> I am suspecting the register configuration we use is off somehow, I will review them thoroughly. Aside from this we are running out of leads here, anyone has input on this?
>
> Thanks in advance!
> JFD
>   
Hi Jean-Francois,

Barry Song, the driver author left ADI quite some time ago
I don't have hardware to test things at the moment.

The EVAL-AD7147 only has sliders and buttons, so I don't know how useful
it will be here.
Need to check if I can find one having a  wheel.

-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


