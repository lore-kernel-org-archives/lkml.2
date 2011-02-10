Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab1BJTGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:06:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15065 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1BJTGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:06:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=weFNOXVIXEDEOxL/qQ/tkbIRfykODiun11ig5s/uLMtCbJ7svijcv/lmliMnN8FRT7
         ARbD7LpVGh4rnqjQTyUA==
MIME-Version: 1.0
In-Reply-To: <20110210040231.GD27040@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
	<20110210040231.GD27040@redhat.com>
Date: Thu, 10 Feb 2011 11:06:37 -0800
Message-ID: <AANLkTimO+CG_iCHZ+9D1EtrZp+z0k0+xUN_WMsqU3NNk@mail.gmail.com>
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't backlogged
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 8:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> - What happens when cfqd->active_generation wraps over? Should we use
>  functions which take care of wrapping.

To be absolutely correct, you're right.  But even if the service tree
becomes completely idle every microsecond, we still have 1/2 million
years before the first wrap.

> - So when generation number changes you want to put the newly backlogged
>  group at the front of tree and not at the end of it? Though it kind
>  of make sense as any continuously backlogged groups will be on service
>  tree for long time and newly backlogged groups are either new IO
>  starting or some application which high think time and which does IO
>  one in a while and does not keep disk occupied for very long time. In
>  such cases it probably is not a bad idea to put newly backlogged
>  groups at the beginning of the tree.

Yes, that's it exactly.

>> @@ -906,6 +905,9 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
>>       if (!RB_EMPTY_NODE(&cfqg->rb_node))
>>               cfq_rb_erase(&cfqg->rb_node, st);
>>       cfqg->saved_workload_slice = 0;
>> +     cfqg->generation_num = cfqd->active_generation;
>> +     if (RB_EMPTY_ROOT(&st->rb))
>> +             cfqd->active_generation++;
>
> I don't understand that what is the significance behind chaning generation
> number when tree is idle? When tree is idle does not mean that few
> recently deleted groups will not get backlogged soon?

It's a result of being both fair and work conserving.  If *all* the
queues are without requests, then whoever next has requests should get
to use the disk fully to be work-conserving.  But if the disk is
always kept busy (by anyone), then there is competition and we have to
provide fairness.

Chad
