Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2IUK0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:26:21 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36321 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2IUK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:26:19 -0400
Message-ID: <505C3FEB.7030606@linux.vnet.ibm.com>
Date: Fri, 21 Sep 2012 15:52:35 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [patch for-3.6] fs, debugfs: fix race in u32_array_read and allocate
 array at open
References: <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <CA+55aFy6=1vW4CN0_g8BgSKKdxZNZj9Yd2WG=0BFKjish=Vw=g@mail.gmail.com> <20120918203713.GB19300@phenom.dumpdata.com> <CA+55aFzZvFeCLF8fw=NYFN7C_8ObwJMeK13bN8xRodKQ0QJkTQ@mail.gmail.com> <20120919191652.GA14631@phenom.dumpdata.com> <alpine.DEB.2.00.1209191427460.6273@chino.kir.corp.google.com> <alpine.DEB.2.00.1209191438200.21378@chino.kir.corp.google.com> <505A7F75.8000405@linux.vnet.ibm.com> <alpine.DEB.2.00.1209191938490.10953@chino.kir.corp.google.com> <20120920211814.GB27312@konrad-lan.dumpdata.com> <alpine.DEB.2.00.1209210216000.18230@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209210216000.18230@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092110-1396-0000-0000-000001E79098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 02:46 PM, David Rientjes wrote:
> u32_array_open() is racy when multiple threads read from a file with a
> seek position of zero, i.e. when two or more simultaneous reads are
> occurring after the non-seekable files are created.  It is possible that
> file->private_data is double-freed because the threads races between
>
> 	kfree(file->private-data);
>
> and
>
> 	file->private_data = NULL;
>
> The fix is to only do format_array_alloc() when the file is opened and
> free it when it is closed.  This means that any thread that holds the
> file open and reads multiple times will see persistent data;

I think you meant we can read data only once. second time onwards we 
don't see any data. (except when fd is forked by child/ races in
threads).

