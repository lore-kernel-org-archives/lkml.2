Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1CURkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:40:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39986 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab1CURkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:40:35 -0400
X-Sasl-enc: ClOT2j6yIKSfSzILiOM87WeKVgp3QXJdgyxwX0X5aM2j 1300729234
Message-ID: <4D878D90.6070100@fastmail.fm>
Date: Mon, 21 Mar 2011 17:40:32 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mac <kmac@poczta.fm>, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
References: <fuopaigyaypsqveewtjx@pwmq>	<4D864A82.4090104@fastmail.fm>	<20110320215826.79cadfe2@lxorguk.ukuu.org.uk>	<6627fbdd-cce6-4717-8920-3a0d7526274b@email.android.com> <20110321112723.248e7a52@lxorguk.ukuu.org.uk>
In-Reply-To: <20110321112723.248e7a52@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2011 11:27, Alan Cox wrote:
> It's quite likely that was as broken before your change as after. The
> locking in the code makes no sense so I flagged it up. The
> nozomi ntty_write also has lots of oddness in it that really needs
> sorting out.
> 
> I suspect that the chunk
> 
>         if (!dc || !port)
>                 return -ENODEV;
> 
>         mutex_lock(&port->tty_sem);
> 
>         if (unlikely(!port->port.count)) {
>                 DBG1(" ");
>                 goto exit;
>         }
> 
> and
> 
>       /* notify card */
>         if (unlikely(dc == NULL)) {
>                 DBG1("No device context?");
>                 goto exit;
>         }
> 
> and the mutex unlock are actually not doing anything
> 
> On the write_room case I think that as the code already uses tty_port
> helpers it needs to simply just return the correct value and not do all
> the other checks. chars_in_buffer() likewise
> 
> So in fact I don't think at this point the tty_sem needs replacing with
> anything, but the various bogus port.count checks want ripping out.
> 
> 

Thank you very much for the explanation. I will do my best to respin the
patch with appropriate changes.

Jack
