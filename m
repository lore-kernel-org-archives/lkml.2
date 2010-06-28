Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0F1Mxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:53:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab0F1Mxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:53:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
       "Gustavo F. Padovan" <gustavo@padovan.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, sds@tycho.nsa.gov,
       lenb@kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 5/5]bluetooth:hci_bcsp Fix operation on 'bcsp->msgq_txseq' may be undefined
Date: Mon, 28 Jun 2010 13:52:56 +0100
Message-ID: <7323.1277729576@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock@gmail.com> wrote:

> -		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq);
> -		bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
> +		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq | ret);
> +		ret = ++(bcsp->msgq_txseq) & 0x07;

I don't know what you're trying to do here, but you seem to be trying to send
the computed value back in time.

The problem is that the compiler is confused about why a '++' operator makes
any sense here.  It doesn't.  It should be a '+ 1' instead.  I think what you
want is:

	-	bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
	+	bcsp->msgq_txseq = (bcsp->msgq_txseq + 1) & 0x07;

David
