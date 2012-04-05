Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2DEKvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:51:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57497 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2DEKvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:51:11 -0400
Date: Thu, 5 Apr 2012 11:53:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Shankarmurthy, Akshay" <akshay.s@ti.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: 8250: Add cpufreq support
Message-ID: <20120405115322.15e6088c@pyramind.ukuu.org.uk>
In-Reply-To: <6F6B80BD2E18844D97BB4B51FE3705C831790EA0@DBDE01.ent.ti.com>
References: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
	<20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
	<6F6B80BD2E18844D97BB4B51FE3705C831790EA0@DBDE01.ent.ti.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012 10:40:55 +0000
"Shankarmurthy, Akshay" <akshay.s@ti.com> wrote:

> Hi,
> 
> On Tue, Apr 03, 2012 at 15:25:30, Alan Cox wrote:
> > > This patch was submitted 2 years ago but didn't make it to the mainline. Now i am reposting it.
> > 
> > Can you fix it instead of just reposting it ?
> > 
> > 
> > > +#ifdef CONFIG_CPU_FREQ
> > > +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> > > +					     unsigned long val, void *data)
> > > +{
> > > +	struct uart_8250_port *p;
> > > +	struct uart_port *uport;
> > 
> > What is your locking model ?
> > 
> 
> I will have a look at this and add the lock if necessary.

At the very least you need reference counts held on the tty struct and to
allow for the tty having vanished under you.

> > 
> > > +static inline void serial8250_cpufreq_deregister(struct uart_8250_port *p)
> > 
> > unregister
> 
> Ok. I will change it.
> 
> > 
> > > +		ret = serial8250_cpufreq_register(uart);
> > > +		if (ret < 0)
> > > +			printk(KERN_ERR "Failed to add cpufreq notifier\n");
> > 
> > Why do this for devices that don't care.
> 
> This is taken care in the code. If the device's frequency doesn't change after the
> change in the cpu frequency then it doesn't go for execution of the function "serial8250_set_termios".

But you still call each function and walk the list for each port on each
CPU transition. There are people with 128 ports in their systems and the
cpu frequency change is latency critical.

Nothing should even be getting registered in such cases.
