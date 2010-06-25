Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0FYB7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 21:59:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33194 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab0FYB7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 21:59:01 -0400
Message-ID: <4C240D61.4000006@austin.ibm.com>
Date: Thu, 24 Jun 2010 20:58:57 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Store sysfs dirent structs in rbtree
References: <4C22C944.4040700@austin.ibm.com> <20100624200424.0a7d3a57@gondolin>
In-Reply-To: <20100624200424.0a7d3a57@gondolin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 01:04 PM, Cornelia Huck wrote:
> On Wed, 23 Jun 2010 21:56:04 -0500,
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> +static void sysfs_dirent_insert(struct sysfs_dirent *sd)
>> +{
>> +	struct sysfs_dirent *parent_sd = sd->s_parent;
>> +	struct sysfs_dirent *d;
>> +	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
>> +	struct rb_node *parent = NULL;
>> +
>> +	while (*p) {
>> +		int cmp_val;
>> +		parent = *p;
>> +		d = to_sysfs_dirent(parent);
>> +
>> +		cmp_val = strcmp(d->s_name, sd->s_name);
>> +		if (cmp_val < 0)
>> +			p = &parent->rb_left;
>> +		if (cmp_val > 0)
>> +			p = &parent->rb_right;
>> +	}
>> +
>> +	rb_link_node(&sd->s_dir.rb_node, parent, p);
>> +	rb_insert_color(&sd->s_dir.rb_node, &parent_sd->s_dir.rb_root);
>> +}
> 
> This will run into trouble if you have duplicate names in different
> namespaces. You won't see it with your patch though, since...
> 
>> @@ -536,14 +572,24 @@
>>  				       const void *ns,
>>  				       const unsigned char *name)
>>  {
>> -	struct sysfs_dirent *sd;
>> -
>> -	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
>> -		if (ns && sd->s_ns && (sd->s_ns != ns))
>> -			continue;
>> -		if (!strcmp(sd->s_name, name))
>> -			return sd;
>> +	struct sysfs_dirent *d;
>> +	struct rb_node **p = &parent_sd->s_dir.rb_root.rb_node;
>> +	struct rb_node *parent = NULL;
>> +
>> +	while (*p) {
>> +		int cmp_val;
>> +		parent = *p;
>> +		d = to_sysfs_dirent(parent);
>> +
>> +		cmp_val = strcmp(d->s_name, name);
>> +		if (cmp_val == 0)
>> +			return d;
>> +		else if (cmp_val < 0)
>> +			p = &parent->rb_left;
>> +		else /* (cmp_val > 0) */
>> +			p = &parent->rb_right;
>>  	}
>> +
>>  	return NULL;
>>  }
> 
> ...you removed the namespace check down here.

Yep, I missed namespaces completely with this patch.  I'll try again.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

