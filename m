Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1HYEod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 00:44:33 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56235 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1HYEoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 00:44:32 -0400
MIME-Version: 1.0
Date: Thu, 25 Aug 2011 13:44:31 +0900
Message-ID: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
Subject: RFC : mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of multiple write blocks.
From: NamJae Jeon <linkinjeon@gmail.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, linus.walleij@linaro.org,
        Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

If card is infinitely holding pull down busy line(data 0) while
writing multiple blocks, write will be blocked in
mmc_wait_for_req_done().
I suggest to use wait_for_completion_timeout instread of
wait_for_completion like the below code.

How do you think about my suggestion ?

Thanks.

------------------------------------------------------------------------------------------------------------------
static void mmc_wait_for_req_done(struct mmc_host *host, struct
mmc_request *mrq)
{
        unsigned int write_timeout = 0;
	
        if(mrq->data != NULL && (mrq->data->flags & MMC_DATA_WRITE) &&
(mrq->cmd->opcode & MMC_WRITE_MULTIPLE_BLOCK)) {
                write_timeout =
usecs_to_jiffies(mrq->data->timeout_ns/1000) * mrq->data->blocks;
                wait_for_completion_timeout(&mrq->completion, write_timeout);
        }
        else wait_for_completion(&mrq->completion);
}
