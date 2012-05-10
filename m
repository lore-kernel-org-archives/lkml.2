Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2EJDgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 23:36:08 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53720 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab2EJDgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 23:36:04 -0400
Date: Thu, 10 May 2012 11:35:51 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120510033551.GA25138@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <CAE9FiQUz2w815gU5vY5b0BPf+1pz_pafgzqVKizJC++z27RTaQ@mail.gmail.com>
 <20120504045205.GA21624@richard>
 <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
 <20120506151715.GA7773@richard>
 <CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
 <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
 <20120507011722.GA8122@richard>
 <CAE9FiQUpcJdAvK=wisNc_zq5c9zDtgEM=MNugDcHN9h3=ZPUcA@mail.gmail.com>
 <20120508024612.GA11485@richard>
 <CAE9FiQUU+a4yQJTiud=aYx2xXcoQZpH2rJyVhj19TQKGN7=2BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUU+a4yQJTiud=aYx2xXcoQZpH2rJyVhj19TQKGN7=2BA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12051003-9574-0000-0000-0000029F0F97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 08:42:59PM -0700, Yinghai Lu wrote:
>>>no, probe_resource will get from start if space is big enough.
>>>
>>>if not, it will try to extend top.
>>
>> Hmm... for example we still have this
>>               parent[70-160]
>> brother1[70-80]  res[90-150]  brother2[151-160]
>>                   ->child[105-140]
>>
>> if we call probe_resource(res, new_res, 16, par, 1, 0xff,
>> IORESOURCE_PCI_FIXED);
>>
>> I think this call is used to allocate a res of size 16 under res.
>> When there is no enough free space, it will expend res, and res->parent.
>>
>> While in this situation, res doesn't have enough free space. so it need
>> to expend itself.
>>
>> In the probe_resource() it tries to extend res on the right side.
>> So even there is enough space between brother1 and res, I think the
>> probe_resource() will not return 0.
>>
>> Do you think my analysis is correct?
>
>it will reduce needed size one by one. so at last it will return
>[91, 104]
Yes, agree. This is the current behavior.

While in this case.
               70-160]
 brother1[70-80]  res[90-150]  brother151-160]
                   ->child

There is free space between 81-89, and 90-104. These two free range add
up to 25, which is more than the required space, 16.

If we have this resource tree. 
          parent[70-180]
 brother1[70-80]  re[90-150]  brothr2[170-180]
                 d[105-140]

There are enough free space between res and brother2.
Then probe_resource will return [141-156] with size 16. 
And also expend res.

So I mean this is the design decision to not count in the free space on
the left? Even there is enough free space?

>
>Yinghai

-- 
Richard Yang
Help you, Help me

