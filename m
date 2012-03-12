Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2CLJ7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:59:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:44927 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab2CLJ7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:59:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung.kim@lge.com>
Subject: [RFD] perf: Integrate logging facilities
Date: Mon, 12 Mar 2012 18:58:49 +0900
Message-ID: <4F5DC8D9.9030608@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

This is my proposal for integrating various logging facilities used on perf 
tools. We now have a couple of ways to report something bad happened to user 
as follows:

  * fprintf(stderr, ...)
  * perror
  * die/error/warning/usage
  * pr_err/pr_warning/pr_info/pr_debug
  * ui__error/ui__warning

Also we use dump_printf() when -D given. Some of them are aware of TUI (based 
on the value of use_browser), but other's are not. In addition, we should 
consider the case of python binding. There also is a patch proposed by Pekka 
Enberg which add a GTK+ GUI support on perf report. All of these make things 
complicated when someone - like me - who has no idea of this situation wants 
to leave a message for the user. And their meaning and expected behaivor is 
somewhat vague AFAICS.

So I suggest that we should select one method and deprecates other usages, 
make it flexible to deal with current complexity and possible future 
improvements. IMHO pr_err or ui__error (and its friends) can be chosen as the 
candidate. I prefer the pr_err() since it's a standard method of kernel 
logging and shorter to type :). And it supports more than 4 levels to 
differentiate its priory so that the developer can use appropriate one 
depending on the case. Now I think we can provide following semantics for each 
function:

  * pr_err: Fatal error occurred. perf cannot continue to work anymore and
	exits immediately once user noticed - by pressing keys, clicking
	buttons (if GUI provided) or simply printing it on terminal.
  * pr_warning: Serious error occurred. perf may or may not continue to work -
	if UI somehow provides a way to alter related options dynamically?
	User also will be imformed the message by pressing keys or clicking
	buttons. In case of stdio, the message will be followed by sleep(1).
  * pr_info: Just a informative message and can be buried with other messages.
	UI will put this on the helpline. perf will keep doing its work.
  * pr_debug: Messages to make debugging easy. It can be seen only -v option
	is given. UI will put this on the helpline too.

To implement this, I suggest using a table of function pointers to each 
method. By default it's connected to terminal printf-style functions. When 
setup_browser() is called, it'll be overridden to approriate ones. This way, 
we don't need to care about the timing when this function is called - since 
there's a time gap between use_browser is set (by config parser) and 
setup_browser() called, thus simply checking the variable can cause a nasty 
problem IMHO. Also python binding should have its own implementation - I have 
no idea on this :).

I think we should stop using fprintf/perror from now on and convert existing 
ones to generic ones. The generic code have to use above functions only, 
although UI specific code can use its own ones. The die, error, warning and 
usage are easy to convert to use generic functions since they're implemented 
by pointer already. And finally ui__error can remove terminal support(?).

This is a rough idea and there can be things I am missing. So I need to listen 
to your advices.

Thanks,
Namhyung

