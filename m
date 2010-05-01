Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0EAWD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 18:03:27 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:58817 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0EAWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 18:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=IWNbWMtmySuTkjmm7AhSAzzpBYWAqgANqQKRbjgIjyAm3zBp4rYGp4U4EMPWhm6m+w
         DTHCSd1Us3MHLcBeSkezWMYz6KgGPwXgVkoX3CHdOYKS/Ke5VL+lDQh2J8+VxwORQ+yZ
         pB3V0v0Do5WStFwOGGODXw7OuRyng8gVSkUYI=
Date: Sat, 1 May 2010 18:55:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org
Subject: Re: [RFC][PATCH 2/2] perf: add perf-inject builtin
Message-ID: <20100501215555.GE24935@ghostprotocols.net>
References: <1272696080-16435-1-git-send-email-tzanussi@gmail.com>
 <1272696080-16435-3-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272696080-16435-3-git-send-email-tzanussi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 01, 2010 at 01:41:20AM -0500, Tom Zanussi escreveu:
> Currently, perf 'live mode' writes build-ids at the end of the
> session, which isn't actually useful for processing live mode events.
> 
> What would be better would be to have the build-ids sent before any of
> the samples that reference them, which can be done by processing the
> event stream and retrieving the build-ids on the first hit.  Doing
> that in perf-record itself, however, is off-limits.
> 
> This patch introduces perf-inject, which does the same job while
> leaving perf-record untouched.  Normal mode perf still records the
> build-ids at the end of the session as it should, but for live mode,
> perf-inject can be injected in between the record and report steps
> e.g.:
> 
> perf record -o - ./hackbench 10 | perf inject -v -b | perf report -v -i -
> 
> perf-inject reads a perf-record event stream and repipes it to stdout.
> At any point the processing code can inject other events into the
> event stream - in this case build-ids (-b option) are read and
> injected as needed into the event stream.
> 
> Build-ids are just the first user of perf-inject - potentially
> anything that needs userspace processing to augment the trace stream
> with additional information could make use of this facility.

Good work, I'd just make "read_buildid" be "dso__read_buildid", make its
'self' parameter be a struct dso pointer, first check if had its build
id read already, read it if not. Yeah, dsos can change, but that is also
not supported in 'perf record', where we do it at the end.

I.e. reducing the cost of build-id processing even in live mode is also
interesting and OK for the normal case of not changing DSOs while a
session is running.

- Arnaldo
