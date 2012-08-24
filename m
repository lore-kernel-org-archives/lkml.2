Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab2HXRAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:00:47 -0400
Received: from postal1-e0.whoi.edu ([128.128.76.87]:58834 "EHLO
	postal1.whoi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2HXRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:00:43 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2012 13:00:43 EDT
Message-ID: <5037B1DF.40503@whoi.edu>
Date: Fri, 24 Aug 2012 12:54:55 -0400
From: Ned Forrester <nforrester@whoi.edu>
Organization: Woods Hole Oceanographic Institution
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Fabio Estevam <festevam@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        "Bastelli Carlo (yahoo)" <carlo_bastelli@yahoo.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: SLAVE Side SPI kernel driver development
References: <1345820228.87750.YahooMailNeo@web29604.mail.ird.yahoo.com>	<CAOMZO5Ds6NKsTCptQXDGZDJasb119hYWqXMzX8nG5WFArysL7A@mail.gmail.com> <201208241738.45601.marex@denx.de>
In-Reply-To: <201208241738.45601.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 11:38 AM, Marek Vasut wrote:
> Dear Fabio Estevam,
> 
>> On Fri, Aug 24, 2012 at 11:57 AM, Bastelli Carlo (yahoo)
> 
> CCing SPI list
> 
>> <carlo_bastelli@yahoo.it> wrote:
>>> Hello, I'm Carlo, I have a difficult task at work, my boss asked me to
>>> develop
>>>
>>>  a driver SPI slave side on embedded ARM processor running Linux.
>>>
>>> Precisely linux occur on the SPI bus as a slave, not master as required
>>> by the hierarchical structure of the current kernel. The new driver
>>> will
>>>
>>>  receive via interrupt and respond when selected by its chip select.
> 
> So a soft-spi ? It's gonna be slow as hell and unstable too.
> 
>>>  Can
>>>  anyone suggest the best way to develop this driver?
> 
> Get a CPU which has SPI-slave capable IP, start from there. If you were to 
> implement soft-spi this way, you'd have to use FIQ on ARM, to be able to handle 
> stuff with reasonable latency ... check how the ps/2-gpio driver is done in 
> Linux ... I tried it, it barely worked, you don't want to go down that road.
> 
>>>  Personally, I
>>>
>>> have identified two main roads, the first if possible to exploit the
>>> structure SPI master driver
> 
> Not happening. You'd have to split the parts from the struct spi_master into 
> common and master-only parts. That's for starters.
> 
>>> with a few tricks that now I can not
>>> define. The second most radical, write a driver for a UART like, but
>>> managing the SPI device.
>>> Thank you for any suggestions or examples.
> 
> First of all, the SPI slave mode is COMPLETELY different from the master mode. 
> You need to react on incoming CS-low ASAP, which might turn out to be a problem 
> on it's own. Then, even if you do, you do not know how long the transfer is 
> going to be, so you need to allocate enough buffers as the transfer progresses 
> onwards.
> 
> In case of your soft-spi, how do you plan to sample the CLK line to sync clock?
> 
>> Marek got spi slave running on a mx28. See his patch:
>> http://www.spinics.net/lists/arm-kernel/msg190860.html
> 
> This was tested (and developed) on this board:
> http://www.denx-cs.de/?q=M28
> 
> The userland code is really easy too, simply pump it into spidev or read from 
> it. But all that is only possible because of the SPI IP in the mx28 is nice.
> 
>> Regards,
>>
>> Fabio Estevam
> 
> Best regards,
> Marek Vasut

I generally agree with the above comments.  A generalized SPI slave must
be able to respond instantly, often within one clock cycle.  This can
only work in hardware, or in an OS like Linux when the activity on the
bus is completely predictable by the Linux slave.  The only cases I know
of are streaming of data in a predictable way between a single master
and single slave (no other devices on the bus).

This topic comes up periodically, but I don't think there has been any
change in the situation for all the time I've followed the discussion.
I recommend that you read the archives of this mailing list to
understand the limitations of a potential slave mode.  The archives can
be found at:

http://sourceforge.net/mailarchive/forum.php?forum_name=spi-devel-general

then look for threads with "slave" in the subject in the following
months (I'd give thread start dates, but parts of the threads are
disconnected in the archives, and this is the easiest way to see all the
parts, day ranges are in parentheses):

2007/04	(13-18)
2007/09/27 and 2007/10 (13-17)
2009/03 (2-3)
2009/12/18 and 2010/1/19 and 2010/02 (14-16)
2010/07 (26) and 2010/08 (13)
2011/01 (28-31) and 2011/02 (1-10)
2011/10 (18)
2012/06 (29-30 and 2012/07 (1-17)

-- 
Ned Forrester                                       nforrester@whoi.edu
Oceanographic Systems Lab                           508-289-2226 Office
Applied Ocean Physics and Engineering Dept.
Woods Hole Oceanographic Institution          Woods Hole, MA 02543, USA
http://www.whoi.edu/
http://www.whoi.edu/page.do?pid=29856
http://www.whoi.edu/hpb/Site.do?id=1532

