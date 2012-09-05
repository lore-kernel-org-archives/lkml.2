Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab2IEA01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:26:27 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:7174 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab2IEA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:26:25 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 04 Sep 2012 16:58:03 -0700
Message-ID: <50469C2F.2060008@synaptics.com>
Date: Tue, 4 Sep 2012 17:26:23 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 5/17] input: rmidev character driver for RMI4 sensors
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com> <1345241877-16200-6-git-send-email-cheiny@synaptics.com> <CACRpkdYGR=YtgyvDjfH4w8OMnn3iZKuRpQKrTVCE=i=gZ1hPuw@mail.gmail.com>
In-Reply-To: <CACRpkdYGR=YtgyvDjfH4w8OMnn3iZKuRpQKrTVCE=i=gZ1hPuw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 11:49 AM, Linus Walleij wrote:
> On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:
>
>> Driver for Synaptics touchscreens using RMI4 protocol.
>
> Really? This looks more like some custom char driver to get a pipe
> into the device from userspace. Put in a proper description of what this
> is for.
>
> If the purpose is to read/write arbitrary addresses in the device,
> you should use regmap's debugfs interface for this instead,
> it is much better suited for the task.

We'll look into using regmap not only for that, but possibly for general 
register access.  It has the potential to greatly simply both the 
arbitrary register access, as well as the driver itself.

>
> (...)
>> +#define RMI_CHAR_DEV_TMPBUF_SZ 128
>> +#define RMI_REG_ADDR_PAGE_SELECT 0xFF
>> +#define REG_ADDR_LIMIT 0xFFFF
>> +
>> +struct rmidev_data {
>> +       /* mutex for file operation*/
>> +       struct mutex file_mutex;
>> +       /* main char dev structure */
>> +       struct cdev main_dev;
>> +
>> +       /* pointer to the corresponding RMI4 device.  We use this to do */
>> +       /* read, write, etc. */
>> +       struct rmi_device *rmi_dev;
>> +       /* reference count */
>> +       int ref_count;
>
> Something tells me you should atleast use <linux/kref.h> for this.
> It also solves a few atomicity problems in a good standard way.
> See Documentation/kref.txt

Roger.


>> +/*store dynamically allocated major number of char device*/
>> +static int rmidev_major_num;
>
> You need to patch your desired major number into
> Documentation/devices.txt'

We were going by the recommendation in Linux Device Drivers (3rd 
edition) to use dynamic major number allocation via alloc_chrdev_region. 
  In particular in section 3.2.3 it says "new numbers are not being 
assigned".  I guess at this point we need to know whether the info in 
LDD3 is authoritative or not.  We can always add a number to 
Documentation/devices.txt if that's the right thing to do, but I'd like 
to make sure our next submission isn't bounced because we did that, 
turning the process into Patch Ping-Pong :-).

In any case, it's likely that switching to the regmap interface would 
make this question irrelevant.


>> +static struct class *rmidev_device_class;
>
> Last time discussed with Greg, class devices were deprecated,
> and you should just use a bus instead. (But not sure.)

The references I found online weren't clear on this, so more 
investigation is required.  We'll defer that till we find out if the 
regmap changes eliminate the need for this.

