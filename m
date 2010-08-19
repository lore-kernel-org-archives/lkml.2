Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0HSOrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:47:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61399 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0HSOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KC7JDULYdIShbuschdxDOMPF8sxGPhb744RlJOBgKH8Fs35TifoCC3JJ5LkHz/5f1Y
         eydGIuh9uIAnRYBJ8AsC7zWZKdpwF5CjUmAQt+rqdsdDAIVEfB/M+AuPTi4H49VtEP1k
         FhviWLKr2YzS0f8Zsu83ciLg/5C2K+UkWecBo=
Date: Wed, 18 Aug 2010 22:33:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Trilok Soni <tsoni@codeaurora.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
Message-ID: <20100819053311.GE5832@core.coreip.homeip.net>
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org>
 <20100813024912.GA2661@core.coreip.homeip.net>
 <4C65BF99.9030601@codeaurora.org>
 <201008131754.49488.dmitry.torokhov@gmail.com>
 <4C6AC393.8000109@codeaurora.org>
 <BC741E3E-377E-45BF-80E1-A60F4E0FDFC9@gmail.com>
 <4C6C52DE.4040700@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6C52DE.4040700@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 05:38:38PM -0400, Neil Leeder wrote:
> Hi Dmitry,
> 
> On 8/17/2010 2:05 PM, Dmitry Torokhov wrote:
> >That suggests that the device responds to at least basic PS/2 queries.
> >
> >>I can see data being passed through the serio driver but the logitech
> >>driver can't process it.
> >>
> >
> >What about loading psmouse module with proto=bare?
> >
> >Could you also dump the data received from touchpad during probing?
> >
> 
> It appears the controller does somewhat respond as a PS/2 device.
> The first problem is it only responds to CMD_GETID correctly about
> 50% of the time. Sometimes it responds well with a 0x00, other times
> with 0xfa, which causes psmouse_probe to not recognize it as a
> pointing device.
> 
> [    1.037223] wpce775x_send len=1 data=f2
> [    1.054412] wpce775x_recv ... data_in=fa fa 64 0 0 0 0 0 fa 0 0 0
> 0 0 0 0
> 
> It also doesn't respond well to CMD_GETINFO, which is why it gets
> mis-detected as the wrong device type. As an aside, I'm not sure if
> combining separate commands into one i2c packet is correct, but
> separating them didn't seem to produce better results either.
> 
> [    1.723943] wpce775x_send len=3 data=e8 3 e6
> [    1.735666] wpce775x_recv ... data_in=fa fa 64 0 0 0 0 0 fa 0 0 0
> 0 0 0 0
> [    1.735892] wpce775x_send len=3 data=e6 e6 e9
> [    1.748281] wpce775x_recv ... data_in=fe fa 64 0 0 0 0 0 fa 0 0 0
> 0 0 0 0
> [    1.748500] wpce775x_send len=3 data=e8 0 e6
> [    1.760233] wpce775x_recv ... data_in=fa fa 64 0 0 0 0 0 fa 0 0 0
> 0 0 0 0
> [    1.760457] wpce775x_send len=3 data=e6 e6 e9
> [    1.772876] wpce775x_recv ... data_in=fe fa 64 0 0 0 0 0 fa 0 0 0
> 0 0 0 0
> 
> Using proto=bare gets around the GETINFO failure, but doesn't help
> with the more important GETID failure.

Does it help if you change write() to transmit (and read) 1 byte at a time?

> 
> The other issue is that when the serio driver requests up to 16
> bytes over i2c, the controller responds with 16 bytes of data, which
> appear to be the 3 flags/X/Y regs plus 13 bytes of irrelevant data.
> This all gets passed to psmouse which interprets it 3 bytes at a
> time as movement data. Not only does the extra data get interpreted
> as movement info, but it causes subsequent real data to be
> mis-aligned and wrongly interpreted.
> 
> [  115.915558] wpce775x_recv ... data_in=28 1 ff 0 0 0 0 0 9c 0 0 0 0 0 0 0
> [  115.915649] psmouse_process_byte data=28 01 ff rel_x=1 rel_y=1
> <--- OK
> [  115.915688] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.915714] psmouse_process_byte data=00 00 9c rel_x=0 rel_y=-156
> <--- bad
> [  115.915745] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.915771] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.928269] wpce775x_recv ... data_in=28 1 fe 0 0 0 0 0 9c 0 0 0 0 0 0 0
> [  115.928357] psmouse_process_byte data=00 28 01 rel_x=40 rel_y=-1
> <--- wrong
> [  115.928396] psmouse_process_byte data=fe 00 00 rel_x=0 rel_y=0
> <--- wrong
> [  115.928426] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.928457] psmouse_process_byte data=9c 00 00 rel_x=0 rel_y=0
> [  115.928484] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.939728] wpce775x_recv ... data_in=28 1 ff 0 0 0 0 0 9c 0 0 0 0 0 0 0
> [  115.939818] psmouse_process_byte data=00 00 28 rel_x=0 rel_y=-40
> <--- wrong
> [  115.939857] psmouse_process_byte data=01 ff 00 rel_x=255 rel_y=0
> <--- wrong
> [  115.939889] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.939916] psmouse_process_byte data=00 9c 00 rel_x=156 rel_y=0
> <--- bad
> [  115.939947] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> [  115.939972] psmouse_process_byte data=00 00 00 rel_x=0 rel_y=0
> 
> Is there a way to get the serio driver to only read 3 bytes of data
> per interrupt?
> 

One way would be to look for PSMOUSE_CMD_ENABLE/PSMOUSE_CMD_DISABLE
(0xf4/0xf5) in ->write() method to switch between 1 and 3-byte transfers.

Thanks.

-- 
Dmitry
