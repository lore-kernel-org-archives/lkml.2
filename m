Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab1FWDSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:18:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:12389 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758406Ab1FWDSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:18:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,410,1304319600"; 
   d="scan'208";a="17217291"
Date: Thu, 23 Jun 2011 11:25:52 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 09/11] spi-dw: Fix condition in spi_dw_{writer/reader}
Message-ID: <20110623112552.6f22c3de@feng-i7>
In-Reply-To: <4E02AE6E.5010307@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
	<1308794413-11069-10-git-send-email-dirk.brandewie@gmail.com>
	<20110623104506.3cfd55ce@feng-i7>
	<4E02AE6E.5010307@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 11:09:34 +0800
Dirk Brandewie <dirk.brandewie@gmail.com> wrote:

> On 06/22/2011 07:45 PM, Feng Tang wrote:
> > On Thu, 23 Jun 2011 10:00:11 +0800
> > "dirk.brandewie@gmail.com"<dirk.brandewie@gmail.com>  wrote:
> >
> >> From: Dirk Brandewie<dirk.brandewie@gmail.com>
> >>
> >> Fix the condition based on whether the current transfer has a tx/rx
> >> buffer.
> >>
> >> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
> >> ---
> >>   drivers/spi/spi-dw.c |    6 +++---
> >>   1 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> >> index cc38aa0..35b952b 100644
> >> --- a/drivers/spi/spi-dw.c
> >> +++ b/drivers/spi/spi-dw.c
> >> @@ -193,8 +193,8 @@ static void spi_dw_writer(struct spi_dw *dws)
> >>   	u16 txw = 0;
> >>
> >>   	while (max--) {
> >> -		/* Set the tx word if the transfer's original "tx"
> >> is not null */
> >> -		if (dws->tx_end - dws->len) {
> >> +		/* Set the tx word if the transfer's "tx" is not
> >> null */
> >> +		if (dws->tx) {
> >
> > No, in current mainstream code, the dws->tx is changing, see code:
> > 	dws->tx += dws->n_bytes;
> > so we have to use if (dws->tx_end - dws->len) for now, maybe
> > we can use some bit to indicate whether the original tx is null
> 
> If dws->tx is non-null then it points to a valid buffer, it is
> unconditionally set with dws->tx = (void *)transfer->tx_buf when the
> transfer is setup.  if the original transfer->tx_buf is non-null then
> this change works.

dws->tx is changing as I said, non-null doesn't mean the value is valid,
when the original tx is null, we don't access it at all, it's just a
indicator of whether the dws->len of zeor has been filled to FIFO.

This logic may looks confusing, but it's correct after years of test.

> 
> >
> >>   			if (dws->n_bytes == 1)
> >>   				txw = *(u8 *)(dws->tx);
> >>   			else
> >> @@ -213,7 +213,7 @@ static void spi_dw_reader(struct spi_dw *dws)
> >>   	while (max--) {
> >>   		rxw = dw_readw(dws, dr);
> >>   		/* Care rx only if the transfer's original "rx"
> >> is not null */
> >> -		if (dws->rx_end - dws->len) {
> >> +		if (dws->rx) {
> >>   			if (dws->n_bytes == 1)
> >>   				*(u8 *)(dws->rx) = rxw;
> >>   			else
> 
