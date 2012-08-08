Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2HHPfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:35:55 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45906 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2HHPfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:35:54 -0400
Message-ID: <50228750.3030108@cs.wisc.edu>
Date: Wed, 08 Aug 2012 10:35:44 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: manish.rangankar@qlogic.com, open-iscsi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [SCSI] qla4xxx: support iscsiadm session mgmt
References: <20120614182745.GA6383@elgon.mountain> <20120808150022.GA3734@mwanda>
In-Reply-To: <20120808150022.GA3734@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 10:00 AM, Dan Carpenter wrote:
> I never heard back on this.  This buffer overflow is still present
> in the current code.
> 

Qlogic just sent a patch yesterday.
http://marc.info/?l=linux-scsi&m=134434199930938&w=2

> regards,
> dan carpenter
> 
> On Thu, Jun 14, 2012 at 09:27:45PM +0300, Dan Carpenter wrote:
>> Hi Manish,
>>
>> The patch b3a271a94d00: "[SCSI] qla4xxx: support iscsiadm session 
>> mgmt" from Jul 25, 2011, leads to the following warning:
>> drivers/scsi/qla4xxx/ql4_os.c:4479 qla4xxx_get_ep_fwdb()
>> 	 warn: casting from 16 to 28 bytes
>>
>> (Sort of).
>>
>> drivers/scsi/qla4xxx/ql4_os.c qla4xxx_ep_connect()
>>    705          qla_ep = ep->dd_data;
>>    706          memset(qla_ep, 0, sizeof(struct qla_endpoint));
>>    707          if (dst_addr->sa_family == AF_INET) {
>>    708                  memcpy(&qla_ep->dst_addr, dst_addr, sizeof(struct sockaddr_in));
>>    709                  addr = (struct sockaddr_in *)&qla_ep->dst_addr;
>>    710                  DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI4\n", __func__,
>>    711                                    (char *)&addr->sin_addr));
>>    712          } else if (dst_addr->sa_family == AF_INET6) {
>>    713                  memcpy(&qla_ep->dst_addr, dst_addr,
>>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>    714                         sizeof(struct sockaddr_in6));
>>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>
>> Both qla_ep->dst_addr and dst_addr are type struct sockaddr.  We are
>> copying sizeof(struct sockaddr_in6) bytes which is 12 bytes larger.  I
>> don't know the actual size of qla_ep->dst_addr but dst_addr is allocated
>> in qla4xxx_get_ep_fwdb() as a struct sockaddr.  So we are copying past
>> the end of the struct here and it's possibly an information leak or even
>> a memory corruption issue depending on how much space ep->dd_data has.
>>
>>    715                  addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
>>    716                  DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI6\n", __func__,
>>    717                                    (char *)&addr6->sin6_addr));
>>    718          }
>>
>> regards,
>> dan carpenter

