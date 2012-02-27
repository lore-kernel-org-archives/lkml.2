Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2B0Qnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:43:51 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:20488 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752599Ab2B0Qnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:43:50 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KZAD5MMVM1mOV9UWAFQK3yqxDzVUwmghBIUcfqL818qz2TG
 KjZxmVnanjduYu6w5rhuDAVmziCuj6YT57MKYWgEW.bTzTUPp7WcNRJ8_iF2
 O_8qRmBU09h3n8qy6nwXffkpbOgEAaCBCxiBOCUmgU7N09eVtM5b6h5o9Lc8
 NBIY72t5V_QY0kfAOaUZjQL3.1OcLzjFr7AfFDXix52Epp8Bz7FFeT04fTSM
 nVsSDXBhjzjggLXPdfk0t5D.qA6iAbfcwDG_6q32x7oiuw7i5TOMD3zWTsCz
 ILnzTMbw_jO3O_VrTjEnR9HEmm.UiWSoBuGF8gO3SEumct.WGYsJg8Zu3hQp
 ZeEsEQ5v.sf4DvxSOHA61NLEdXeJ_mObc6QTT6kOImRdIq0zysFR.6q54kD1
 u
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 27 Feb 2012 10:43:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <87zkc7eshq.fsf@xmission.com>
Message-ID: <alpine.DEB.2.00.1202271039320.29787@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202241131400.3726@router.home> <87zkc7eshq.fsf@xmission.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Eric W. Biederman wrote:

> Taking a quick look it does appear that in cpuset_mems_allowed and it's
> cousins we never sleep under "callback_mutex" so that lock looks like it
> could become a spinlock.
>
> But I have to say something just bothers me about the permissions for
> modifying an mm living in the task.  We can have different rules
> for modifying an mm depending on the path to tme mm?

Yes. Permissions are associated with pids which refer to tasks. Tasks have
address spaces and tasks may share address spaces.

> Especially in things like which numa nodes we can put pages in?

Things = address spaces? The page migration functionality is about moving
the location of physical memory from one numa node to the other. It does
not affect the execution just the latencies experienced by the processes.

> So by specifying a different pid to access them mm through the call can
> either work or succeed?  Are these checks really sane?

Yes if you can create two pids with the same address space and give
those those pids to different owners then the permission checks on one
may fail and succeed on the other. We have no way to refer to address
spaces from user space outside of a pid.

