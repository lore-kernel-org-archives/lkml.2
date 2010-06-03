Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0FCVtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:49:22 -0400
Received: from mail.vyatta.com ([76.74.103.46]:51478 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0FCVtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:49:20 -0400
Date: Thu, 3 Jun 2010 14:49:13 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
Message-ID: <20100603144913.24828629@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam>
	<alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
	<20100603120313.10a73b20@nehalam>
	<alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems it isn't related to initial jiffies. 
Initializing the values (though a good idea), doesn't solve the
problem. Still failed.  So dazed and confused, went back and reran
kernel with jiffies=0 showed same problem, just took multiple boots
to reproduce.

>  	for (dr = 0; dr < N_DRIVE; dr++) {
> @@ -4267,6 +4269,9 @@ static int __init floppy_init(void)
>  		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
>  		set_bit(FD_VERIFY_BIT, &UDRS->flags);
>  		UDRS->fd_device = -1;
> +		UDRS->last_checked = jiffies;
> +		UDRS->select_date = jiffies;
> +		UDRS->spinup_date = jiffies;
>  		floppy_track_buffer = NULL;
>  		max_buffer_sectors = 0;
>  	}

So still a race that shows up with KVM (fast floppy?) and manifests
as floppy_ready or reset_interrupt OOPS.
