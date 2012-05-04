Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2EDCra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:47:30 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:59756 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab2EDCr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:47:28 -0400
Date: Fri, 4 May 2012 10:47:21 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120504024721.GA6775@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <20120410090306.GA7056@richard>
 <20120422155202.GA13540@richard>
 <CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
 <CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
 <CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
 <20120503065455.GA30042@richard>
 <CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050316-5140-0000-0000-0000012E4D63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:33:17AM -0700, Yinghai Lu wrote:
>On Wed, May 2, 2012 at 11:54 PM, Richard Yang
><weiyang@linux.vnet.ibm.com> wrote:
>> On Wed, Apr 25, 2012 at 09:28:19AM -0700, Yinghai Lu wrote:
>>>On Wed, Apr 25, 2012 at 2:47 AM, Wei Yang <weiyang.kernel@gmail.com> wrote:
>>>>> busn_alloc patchset should address your concern.
>>>>>
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>>>> for-pci-busn-alloc
>>
>> For some functions, such as probe_resource() would you mind add some
>> comments?  Such as explain the parameter usage.
>> That would help for reading the function.
>
>I updated for-pci-busn-alloc branch with updating of probe_resource()...
>and removing bus->secondary and subordinate.
>
You mean you remove the bus->secondary field?
So the pci_bus->number hold the bus number?
I think this is a huge work.
>Please check if you can understand it ...
>
>http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=7de8df57b223d54af95ffe67f8da2dd39a265971
Some question:

+static resource_size_t __find_res_top_free_size(struct resource *res,
+                                                int skip_nr)
+{
+       resource_size_t n_size;
+       struct resource tmp_res;
+
+       */
+        *   find out free number below res->end that we can use.
+        *      res->start to res->start + skip_nr - 1 can not be used.
+        */
+       n_size = resource_size(res);
+       if (n_size <= skip_nr)
+               return 0;
+
+       n_size -= skip_nr;
+       memset(&tmp_res, 0, sizeof(struct resource));
+       while (n_size > 0) {
+               int ret;
+
+               ret = __allocate_resource(res, &tmp_res, n_size,
+                       res->end - n_size + skip_nr, res->end,
+                       1, NULL, NULL, false);
+               if (ret == 0) {
+                       __release_resource(&tmp_res);
+                       break;
+               }
+               n_size--;
+       }
+
+       return n_size;
+}
So this is trying to find out the biggest free space of res?
On the right side?

For example we have , res like
   90-150
        105-140
The __find_res_top_free_size() will return 10 instead of 15. 
So this is the design decision to find the right side free resouce not
the left side?

>
>Thanks
>
>Yinghai

-- 
Richard Yang
Help you, Help me

