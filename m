Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab1FWDJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:09:37 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41072 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab1FWDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q1JRaQfpX4NjyQKc8uTN1Fbpg0CKULYmyCU5DIbguCiV/R+0oa9xLWBXllUM/Boo83
         lJ3prQZaQkKO/ZkavfiKFUJj64yhiGdK34cTAn8SMdf7OEFZgANLR5bRrasADsP7rec2
         Vkbj/He1Zv7Ahq8XUDO6f5nl7PwR3p5TdExFY=
Message-ID: <4E02AE6E.5010307@gmail.com>
Date: Wed, 22 Jun 2011 20:09:34 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Thunderbird/3.1.10
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 09/11] spi-dw: Fix condition in spi_dw_{writer/reader}
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>	<1308794413-11069-10-git-send-email-dirk.brandewie@gmail.com> <20110623104506.3cfd55ce@feng-i7>
In-Reply-To: <20110623104506.3cfd55ce@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 07:45 PM, Feng Tang wrote:
> On Thu, 23 Jun 2011 10:00:11 +0800
> "dirk.brandewie@gmail.com"<dirk.brandewie@gmail.com>  wrote:
>
>> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>>
>> Fix the condition based on whether the current transfer has a tx/rx
>> buffer.
>>
>> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
>> ---
>>   drivers/spi/spi-dw.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
>> index cc38aa0..35b952b 100644
>> --- a/drivers/spi/spi-dw.c
>> +++ b/drivers/spi/spi-dw.c
>> @@ -193,8 +193,8 @@ static void spi_dw_writer(struct spi_dw *dws)
>>   	u16 txw = 0;
>>
>>   	while (max--) {
>> -		/* Set the tx word if the transfer's original "tx"
>> is not null */
>> -		if (dws->tx_end - dws->len) {
>> +		/* Set the tx word if the transfer's "tx" is not
>> null */
>> +		if (dws->tx) {
>
> No, in current mainstream code, the dws->tx is changing, see code:
> 	dws->tx += dws->n_bytes;
> so we have to use if (dws->tx_end - dws->len) for now, maybe
> we can use some bit to indicate whether the original tx is null

If dws->tx is non-null then it points to a valid buffer, it is unconditionally 
set with dws->tx = (void *)transfer->tx_buf when the transfer is setup.  if the 
original transfer->tx_buf is non-null then this change works.

>
>>   			if (dws->n_bytes == 1)
>>   				txw = *(u8 *)(dws->tx);
>>   			else
>> @@ -213,7 +213,7 @@ static void spi_dw_reader(struct spi_dw *dws)
>>   	while (max--) {
>>   		rxw = dw_readw(dws, dr);
>>   		/* Care rx only if the transfer's original "rx" is
>> not null */
>> -		if (dws->rx_end - dws->len) {
>> +		if (dws->rx) {
>>   			if (dws->n_bytes == 1)
>>   				*(u8 *)(dws->rx) = rxw;
>>   			else

