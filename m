Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993Ab2COKIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:08:19 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52416 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2COKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:08:17 -0400
Date: Thu, 15 Mar 2012 10:08:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
In-Reply-To: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 02:06:43 +0000
"Tu, Xiaobing" <xiaobing.tu@intel.com> wrote:

> From: Xiaobing Tu <xiaobing.tu@intel.com>
> 
> tty_buffer_request_room is well protected, but while after it returns,
>  it releases the port->lock. tty->buf.tail might be modified

This can only occur in a way that matters if you have multiple writers to
the tty buffer. 

It is a design requirement of the tty layer that your input is single
threaded paths and this is true for existing drivers. There is a good
reason it is true as well - ordering of bytes is defined for serial data,
any parallel writer breaks that ordering even if you have locks in
tty_insert_flip_*.

In practice that means that the tail pointer has a single incrementer and
the reader is the ldisc processing queue. 

So NAK pending a lot more explanation and an actual case where you can
show it is required.

Under what situations with what in tree driver do you see a problem ?


Alan
