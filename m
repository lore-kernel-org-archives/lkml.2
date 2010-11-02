Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0KBODX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:03:23 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57153 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0KBODV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:03:21 -0400
Message-ID: <4CD015F6.5060507@stericsson.com>
Date: Tue, 2 Nov 2010 14:45:26 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: regulator disable supply fix
References: <1288700549-28535-1-git-send-email-mattias.wallin@stericsson.com> <20101102131952.GC21476@opensource.wolfsonmicro.com>
In-Reply-To: <20101102131952.GC21476@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/02/2010 02:19 PM, Mark Brown wrote:
> On Tue, Nov 02, 2010 at 01:22:29PM +0100, Mattias Wallin wrote:
>> This patch fixes a disable failure when regulator supply is used.
>> A while loop in regulator disable checks for supply pointer != NULL
>> but the pointer is not always updated, resulting in the while loop
>> running too many times causing a disable failure.
> 
>> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> 
> Hrm.  This does fix the problem which is needed so:
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
>> ---
>>  drivers/regulator/core.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
>> index f1d10c9..dc7d36e 100644
>> --- a/drivers/regulator/core.c
>> +++ b/drivers/regulator/core.c
>> @@ -1424,6 +1424,7 @@ int regulator_disable(struct regulator *regulator)
>>  	/* decrease our supplies ref count and disable if required */
>>  	while (supply_rdev != NULL) {
>>  		rdev = supply_rdev;
>> +		supply_rdev = NULL;
>>  
>>  		mutex_lock(&rdev->mutex);
>>  		_regulator_disable(rdev, &supply_rdev);
> 
> but this does smell a bit like it ought to be in the _regulator_disable()
> call rather than the caller.

Would you prefer below solution instead?

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dc7d36e..51f66b2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1359,6 +1359,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
                struct regulator_dev **supply_rdev_ptr)
 {
        int ret = 0;
+       *supply_rdev_ptr = NULL;
 
        if (WARN(rdev->use_count <= 0,
                        "unbalanced disables for %s\n",


