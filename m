Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1EULpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 07:45:43 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:33041 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab1EULpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 07:45:40 -0400
Message-ID: <4DD7A5DB.7050000@bfs.de>
Date: Sat, 21 May 2011 13:45:31 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 04/12] staging: usbip: stub_main.c: code cleanup
References: <cover.1305866084.git.mfm@muteddisk.com> <14e39daa97f8475ec12c9ed6a2e95ba344f1c1ee.1305866084.git.mfm@muteddisk.com> <4DD62F8A.90208@bfs.de> <20110520184517.GB83316@haskell.muteddisk.com>
In-Reply-To: <20110520184517.GB83316@haskell.muteddisk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 20.05.2011 20:45, schrieb matt mooney:
> On 11:08 Fri 20 May     , walter harms wrote:
>>
>>
>> Am 20.05.2011 06:36, schrieb matt mooney:
>>> Remove match_find() and replace with get_busid_idx(); change
>>> get_busid_priv(), add_match_busid(), and del_match_busid() to use
>>> get_busid_idx(); and cleanup code in the other functions.
>>>
>>> Signed-off-by: matt mooney <mfm@muteddisk.com>
>>> ---
>>>  drivers/staging/usbip/stub_main.c |  147 ++++++++++++++++++-------------------
>>>  1 files changed, 73 insertions(+), 74 deletions(-)
>>>
>>> diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
>>> index 0ca1462..00398a6 100644
>>> --- a/drivers/staging/usbip/stub_main.c
>>> +++ b/drivers/staging/usbip/stub_main.c
>>> @@ -50,82 +50,90 @@ static void init_busid_table(void)
>>>  	spin_lock_init(&busid_table_lock);
>>>  }
>>>  
>>> -int match_busid(const char *busid)
>>> +/*
>>> + * Find the index of the busid by name.
>>> + * Must be called with busid_table_lock held.
>>> + */
>>> +static int get_busid_idx(const char *busid)
>>>  {
>>>  	int i;
>>> +	int idx = -1;
>>>  
>>> -	spin_lock(&busid_table_lock);
>>>  	for (i = 0; i < MAX_BUSID; i++)
>>>  		if (busid_table[i].name[0])
>>>  			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
>>> -				/* already registerd */
>>> -				spin_unlock(&busid_table_lock);
>>> -				return 0;
>>> +				idx = i;
>>> +				break;
>>>  			}
>>> -	spin_unlock(&busid_table_lock);
>>> -
>>> -	return 1;
>>> +	return idx;
>>>  }
>>>  
>>>  struct bus_id_priv *get_busid_priv(const char *busid)
>>>  {
>>> -	int i;
>>> +	int idx;
>>> +	struct bus_id_priv *bid = NULL;
>>>  
>>>  	spin_lock(&busid_table_lock);
>>> -	for (i = 0; i < MAX_BUSID; i++)
>>> -		if (busid_table[i].name[0])
>>> -			if (!strncmp(busid_table[i].name, busid, BUSID_SIZE)) {
>>> -				/* already registerd */
>>> -				spin_unlock(&busid_table_lock);
>>> -				return &(busid_table[i]);
>>> -			}
>>> +	idx = get_busid_idx(busid);
>>> +	if (idx >= 0)
>>> +		bid = &(busid_table[idx]);
>>>  	spin_unlock(&busid_table_lock);
>>>  
>>> -	return NULL;
>>> +	return bid;
>>>  }
>>>  
>>>  static int add_match_busid(char *busid)
>>>  {
>>>  	int i;
>>> -
>>> -	if (!match_busid(busid))
>>> -		return 0;
>>> +	int ret = -1;
>>>  
>>>  	spin_lock(&busid_table_lock);
>>> +	/* already registered? */
>>> +	if (get_busid_idx(busid) >= 0) {
>>> +		ret = 0;
>>> +		goto out;
>>> +	}
>>> +
>>>  	for (i = 0; i < MAX_BUSID; i++)
>>>  		if (!busid_table[i].name[0]) {
>>>  			strncpy(busid_table[i].name, busid, BUSID_SIZE);
>>
>> i am missing an if() here ??
> 
> I am not sure what you mean. It should be correct.
>  

ups, sorry my fault
missread it as strcmp() everything is fine now.

re,
 wh

