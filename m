Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0FWT4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:56:09 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:54351 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0FWT4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:56:07 -0400
Subject: Re: [RFC] tpm_tis: Fix subsequent suspend failures
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <20100623121850.e000ac8b.akpm@linux-foundation.org>
Date: Wed, 23 Jun 2010 16:55:54 -0300
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
       tpmdd-devel@lists.sourceforge.net,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>, jmorris@namei.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5204AD54-F4BF-49A8-9168-3FCA112AAA2B@linux.vnet.ibm.com>
References: <201006091227.15729.helmut.schaa@googlemail.com> <201006091511.09810.helmut.schaa@googlemail.com> <1277176124.32011.4.camel@blackbox.ibm.com> <20100623121850.e000ac8b.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 23, 2010, at 4:18 PM, Andrew Morton wrote:

> On Tue, 22 Jun 2010 00:08:44 -0300
> Rajiv Andrade <srajiv@linux.vnet.ibm.com> wrote:
> 
>> On Wed, 2010-06-09 at 15:11 +0200, Helmut Schaa wrote:
>>> Fix subsequent suspends by issuing tpm_continue_selftest during resume.
>>> Otherwise, the tpm chip seems to be not fully initialized and will reject
>>> the save state command during suspend, thus preventing the whole system
>>> to suspend.
>>> 
>>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>>> ---
>>> 
>>> Not sure if the platform resume method should be fixed in the same way.
>>> Plase review.
>>> 
>>> Thanks,
>>> Helmut
>>> 
>>> drivers/char/tpm/tpm_tis.c |    9 ++++++++-
>>> 1 files changed, 8 insertions(+), 1 deletions(-)
>>> 
>>> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>>> index 24314a9..1030f84 100644
>>> --- a/drivers/char/tpm/tpm_tis.c
>>> +++ b/drivers/char/tpm/tpm_tis.c
>>> @@ -623,7 +623,14 @@ static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
>>> 
>>> static int tpm_tis_pnp_resume(struct pnp_dev *dev)
>>> {
>>> -	return tpm_pm_resume(&dev->dev);
>>> +	struct tpm_chip *chip = pnp_get_drvdata(dev);
>>> +	int ret;
>>> +
>>> +	ret = tpm_pm_resume(&dev->dev);
>>> +	if (!ret)
>>> +		tpm_continue_selftest(chip);
>>> +
>>> +	return ret;
>>> }
>>> 
>>> static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>> 
>> Sorry the ones on CC, previous message got messed up by the mail client.
>> 
>> This patch fixes https://bugzilla.kernel.org/show_bug.cgi?id=16256
>> 
>> Link to original post given it wasn't submitted to LKML originally:
>> http://marc.info/?l=tpmdd-devel&m=127609160616162&w=2
>> 
>> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>> 
> 
> (top-posting repaired.  Please don't do that).
> 
> This wasn't a very good way to send a patch.  I edited the diff,
> reconstructed the patch and then assembled a decent-looking changelog. 
> I also changed your acked-by to the required signed-off-by, because you
> were on the patch's delivery path.
> 
> Pretty please: next time, prepare a proper mergeable patch with the
> correct attributions and signoffs?  Thanks.

Sure, sorry. I was just not certain if I could just resent Helmut's patch to LKML without messing with his authorship.

Thanks,
Rajiv