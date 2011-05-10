Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1EJJry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:47:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:40132 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab1EJJrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:47:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,345,1301900400"; 
   d="scan'208";a="433503964"
Date: Tue, 10 May 2011 10:32:56 +0100
From: Alan Cox <alan@linux.intel.com>
To: Amit Virdi <amit.virdi@st.com>
Cc: <linux-input@vger.kernel.org>, <samuel@sortiz.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: Re: BUG: sleeping function called from invalid context
Message-ID: <20110510103256.58d61861@bob.linux.org.uk>
In-Reply-To: <4DC8CF50.4040003@st.com>
References: <4DC8CF50.4040003@st.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On analysis, I found that this is due to the change introduced in 
> tty_ioctl.c where the termios mutex is taken to protect against
> parallel throttle/unthrottle. Probably IrCOMM stack code wasn't
> tested before merging this patch.
> 
> Please suggest what should be done with the IrCOMM protocol stack
> code to resolve this problem?

It looks like the comments are wrong 

        /*
         * Just give it over to the line discipline. There is no need to
         * involve the flip buffers, since we are not running in an
        interrupt
         * handler
         */


appears to be completely untrue

I suspect it just needs to use the tty_flip_buffer functions properly
instead of trying to do clever shortcuts


	tty_insert_flip_string(self->tty, skb->data, skb->len);
	tty_flip_buffer_push(self->tty);

