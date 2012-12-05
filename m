Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2LEB4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:56:44 -0500
Received: from intranet.asianux.com ([58.214.24.6]:37996 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2LEB4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:56:41 -0500
X-Spam-Score: -100.8
Message-ID: <50BEAA0E.9000603@asianux.com>
Date: Wed, 05 Dec 2012 09:57:34 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <20121202151332.3b6a6504@pyramind.ukuu.org.uk> <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com> <20121202181057.097012c6@pyramind.ukuu.org.uk> <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com> <50BC0C84.4060802@asianux.com> <50BCCD4C.8050209@microgate.com>
In-Reply-To: <50BCCD4C.8050209@microgate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月04日 00:03, Paul Fulghum 写道:
> On 12/2/2012 8:20 PM, Chen Gang wrote:
>> pardon (I am just learning)
>>   does 65535 mean HDLC_MAX_FRAME_SIZE ?
>>   why do we need info->max_frame_size >= 4096 ?
>> in drivers/tty/synclink_gt.c:
>> 3550         if (info->max_frame_size < 4096)
>> 3551                 info->max_frame_size = 4096;
>> 3552         else if (info->max_frame_size > 65535)
>> 3553                 info->max_frame_size = 65535;
>> 3554
>>  ...
>> 3603                 info->max_frame_size = 4096;
> 
> The hardware can send and receive HDLC frames up to
> 64K in size. The driver defaults to 4K max frame size
> to save buffer space for the common case
> (line 3603 in alloc_dev()).
> 
> The module parameter max_frame_size can override the default
> in add_device() (lines 3550-3554 are from add_device()
> range checking the module parameter)
> 

  thank you.

  sorry for reply late (yesterday, I have an annual leave for personal things, and not connect net).

by the way:
  does it also need check the length in function rx_get_buf ? 
  (it seems not, but I am not quite sure, can you give a confirm ?)

4779 /*
4780  * pass receive buffer (RAW synchronous mode) to tty layer
4781  * return true if buffer available, otherwise false
4782  */
4783 static bool rx_get_buf(struct slgt_info *info)
4784 {
4785         unsigned int i = info->rbuf_current;
4786         unsigned int count;
4787 
4788         if (!desc_complete(info->rbufs[i]))
4789                 return false;
4790         count = desc_count(info->rbufs[i]);
4791         switch(info->params.mode) {
4792         case MGSL_MODE_MONOSYNC:
4793         case MGSL_MODE_BISYNC:
4794         case MGSL_MODE_XSYNC:
4795                 /* ignore residue in byte synchronous modes */
4796                 if (desc_residue(info->rbufs[i]))
4797                         count--;
4798                 break;
4799         }
4800         DBGDATA(info, info->rbufs[i].buf, count, "rx");
4801         DBGINFO(("rx_get_buf size=%d\n", count));
4802         if (count)
4803                 ldisc_receive_buf(info->port.tty, info->rbufs[i].buf,
4804                                   info->flag_buf, count);
4805         free_rbufs(info, i, i);
4806         return true;
4807 }




-- 
Chen Gang

Asianux Corporation
