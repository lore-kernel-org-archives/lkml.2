Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1ITHkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:40:35 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:35035 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab1ITHke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:40:34 -0400
Message-ID: <4E78433F.2050900@stericsson.com>
Date: Tue, 20 Sep 2011 09:39:43 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: "cjb@laptop.org" <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc : Use wait_for_completion_timeout() instead of wait_for_completion
 in case of write.
References: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon wrote:
> host controller can not rise timeout interrupt in write not read in DMA status. 
> because host can just know whether card is finish to program to use busy line. 
> If unstable card is keep holding busy line while writing using DMA.
> hang problem happen by wait_for_completion. so I think that mmc driver need some exception to avoid this problem.
> I suggest to use wait_for_completion_timeout instead of wait_for_completion.
> 

I see what you are trying to solve, but you can never calculate the 
timeout for this type of operation in such a way. Your timeout involves 
the entire data write operation, how can you ever know how long this 
will take?

I think a much better approach is to make you host driver not using 
"busy signaling" (if that is possible), thus when the DMA job is done 
call mmc_request_done to finalize the data transfer. The mmc framework 
will then send a CMD13 (SEND_STATUS) to make sure the data is written 
before issuing the next request.

BR
Ulf Hansson
