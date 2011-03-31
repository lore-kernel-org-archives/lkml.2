Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1CaQuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:50:37 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:9322 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab1CaQuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:50:35 -0400
Date: Thu, 31 Mar 2011 09:50:35 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: 2.6.39-rc1 regression: NFS - unable to mount some shares
 (bisected)
Message-ID: <20110331165035.GA6778@dtor-ws.eng.vmware.com>
References: <8A85A9B4-D801-476F-B280-CE2B1D04277B@vmware.com>
 <20110331162338.GA32296@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331162338.GA32296@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 09:23:38AM -0700, Dmitry Torokhov wrote:
> Hi Bryan,
> 
> On Wed, Mar 30, 2011 at 03:31:44PM -0700, Dmitry Torokhov wrote:
> > Hi Bryan,
> > 
> > It is actually one of autofs + NIS, mounts that is failing.
> > 
> 
> Some more data about NFS problemi I am seeing. With an older kernel I
> get:
> 
> [dtor@dtor-d630 ~]$ sudo mount -v build-toolchain:/toolchain /mnt/
> mount: no type was given - I'll assume nfs because of the colon
> mount.nfs: timeout set for Thu Mar 31 09:17:38 2011
> mount.nfs: trying text-based options 'vers=4,addr=10.17.52.98,clientaddr=10.20.94.47'
> mount.nfs: mount(2): Operation not permitted
> mount.nfs: trying text-based options 'addr=10.17.52.98'
> mount.nfs: prog 100003, trying vers=3, prot=6
> mount.nfs: trying 10.17.52.98 prog 100003 vers 3 prot TCP port 2049
> mount.nfs: prog 100005, trying vers=3, prot=17
> mount.nfs: trying 10.17.52.98 prog 100005 vers 3 prot UDP port 693
> build-toolchain:/toolchain on /mnt type nfs (rw)
> 
> The failing kernel does it like this:
> 
> [dtor@dtor-ws ~]$ sudo mount -v build-toolchain:/toolchain /mnt
> mount: no type was given - I'll assume nfs because of the colon
> mount.nfs: timeout set for Thu Mar 31 09:14:22 2011
> mount.nfs: trying text-based options 'vers=4,addr=10.17.52.98,clientaddr=10.20.94.123'
> mount.nfs: mount(2): Resource temporarily unavailable
> mount.nfs: Resource temporarily unavailable
> 
> And I can mount it successfully if I explicitly request V3:
> 
> [dtor@dtor-ws ~]$ sudo mount -v -o nfsvers=3 build-toolchain:/toolchain /mnt/
> mount: no type was given - I'll assume nfs because of the colon
> mount.nfs: timeout set for Thu Mar 31 09:22:57 2011
> mount.nfs: trying text-based options 'nfsvers=3,addr=10.17.52.98'
> mount.nfs: prog 100003, trying vers=3, prot=6
> mount.nfs: trying 10.17.52.98 prog 100003 vers 3 prot TCP port 2049
> mount.nfs: prog 100005, trying vers=3, prot=17
> mount.nfs: trying 10.17.52.98 prog 100005 vers 3 prot UDP port 693
> build-toolchain:/toolchain on /mnt type nfs (rw,nfsvers=3)
> 
> The mounts that succeed automatically with the newer kernel do like
> this:
> 
> [dtor@dtor-ws ~]$ sudo mount -v pa-home:/home2 /mnt/
> mount: no type was given - I'll assume nfs because of the colon
> mount.nfs: timeout set for Thu Mar 31 09:20:01 2011
> mount.nfs: trying text-based options 'vers=4,addr=10.17.4.25,clientaddr=10.20.94.123'
> mount.nfs: mount(2): Protocol not supported
> mount.nfs: trying text-based options 'addr=10.17.4.25'
> mount.nfs: prog 100003, trying vers=3, prot=6
> mount.nfs: trying 10.17.4.25 prog 100003 vers 3 prot TCP port 2049
> mount.nfs: prog 100005, trying vers=3, prot=17
> mount.nfs: trying 10.17.4.25 prog 100005 vers 3 prot UDP port 1234
> pa-home:/home2 on /mnt type nfs (rw)
> 
> I am not sure why in failing case we are seeing "resource temporarily
> unavailable" instead of "protocol not supported".
> 

And here is the kernel log with debuggig enabled. Sorry for multiple
posts BTW.

[ 2679.038558] NFS: nfs mount opts='vers=4,addr=10.17.52.98,clientaddr=10.20.94.123'
[ 2679.038910] NFS:   parsing nfs mount option 'vers=4'
[ 2679.039126] NFS:   parsing nfs mount option 'addr=10.17.52.98'
[ 2679.039307] NFS:   parsing nfs mount option 'clientaddr=10.20.94.123'
[ 2679.039490] NFS: MNTPATH: '/toolchain'
[ 2679.039659] --> nfs4_try_mount()
[ 2679.039837] --> nfs4_create_server()
[ 2679.040198] --> nfs4_init_server()
[ 2679.040365] --> nfs4_set_client()
[ 2679.040559] --> nfs_get_client(build-toolchain,v4)
[ 2679.040733] RPC:       looking up machine cred
[ 2679.040909] NFS: get client cookie (0xffff8800685c3c00/0xffff88007a2c2e10)
[ 2679.041143] RPC:       set up xprt to 10.17.52.98 (port 2049) via tcp
[ 2679.041324] RPC:       created transport ffff88007a346000 with 16 slots
[ 2679.041501] RPC:       creating nfs client for build-toolchain (xprt ffff88007a346000)
[ 2679.041895] RPC:       creating UNIX authenticator for client ffff880067dfde00
[ 2679.042273] RPC:       new task initialized, procpid 6568
[ 2679.042447] RPC:       allocated task ffff880060c6d100
[ 2679.042618] RPC:  1843 __rpc_execute flags=0x680
[ 2679.042787] RPC:  1843 call_start nfs4 proc NULL (sync)
[ 2679.042957] RPC:  1843 call_reserve (status 0)
[ 2679.048338] RPC:  1843 reserved req ffff88007a2d6000 xid 094bb2b3
[ 2679.048513] RPC:  1843 call_reserveresult (status 0)
[ 2679.048688] RPC:  1843 call_refresh (status 0)
[ 2679.048860] RPC:  1843 holding NULL cred ffffffffa025da80
[ 2679.049060] RPC:  1843 refreshing NULL cred ffffffffa025da80
[ 2679.049243] RPC:  1843 call_refreshresult (status 0)
[ 2679.049426] RPC:  1843 call_allocate (status 0)
[ 2679.049635] RPC:  1843 allocated buffer of size 96 at ffff88007a343800
[ 2679.049819] RPC:  1843 call_bind (status 0)
[ 2679.049990] RPC:  1843 call_connect xprt ffff88007a346000 is not connected
[ 2679.050200] RPC:  1843 xprt_connect xprt ffff88007a346000 is not connected
[ 2679.050379] RPC:  1843 sleep_on(queue "xprt_pending" time 4297346346)
[ 2679.050556] RPC:  1843 added to queue ffff88007a346320 "xprt_pending"
[ 2679.050732] RPC:  1843 setting alarm for 60000 ms
[ 2679.050901] RPC:       xs_connect scheduled xprt ffff88007a346000
[ 2679.051114] RPC:  1843 sync task going to sleep
[ 2679.051312] RPC:       xs_bind 0.0.0.0:1013: ok (0)
[ 2679.051486] RPC:       worker connecting xprt ffff88007a346000 via tcp to 10.17.52.98 (port 2049)
[ 2679.051857] RPC:       ffff88007a346000 connect status 115 connected 0 sock state 2
[ 2679.052997] RPC:       xs_tcp_state_change client ffff88007a346000...
[ 2679.053190] RPC:       state 1 conn 0 dead 0 zapped -1 sk_shutdown 0
[ 2679.053361] RPC:  1843 __rpc_wake_up_task (now 4297346349)
[ 2679.053529] RPC:  1843 disabling timer
[ 2679.053696] RPC:  1843 removed from queue ffff88007a346320 "xprt_pending"
[ 2679.053870] RPC:       __rpc_wake_up_task done
[ 2679.053961] RPC:  1843 sync task resuming
[ 2679.053961] RPC:  1843 xprt_connect_status: retrying
[ 2679.053961] RPC:  1843 call_connect_status (status -11)
[ 2679.053961] RPC:  1843 call_transmit (status 0)
[ 2679.053961] RPC:  1843 xprt_prepare_transmit
[ 2679.053961] RPC:  1843 rpc_xdr_encode (status 0)
[ 2679.055137] RPC:  1843 marshaling NULL cred ffffffffa025da80
[ 2679.055311] RPC:  1843 using AUTH_NULL cred ffffffffa025da80 to wrap rpc data
[ 2679.055488] RPC:  1843 xprt_transmit(44)
[ 2679.055687] RPC:       xs_tcp_send_request(44) = 44
[ 2679.055866] RPC:  1843 xmit complete
[ 2679.056068] RPC:  1843 sleep_on(queue "xprt_pending" time 4297346352)
[ 2679.056245] RPC:  1843 added to queue ffff88007a346320 "xprt_pending"
[ 2679.056421] RPC:  1843 setting alarm for 60000 ms
[ 2679.056590] RPC:       wake_up_next(ffff88007a346258 "xprt_resend")
[ 2679.056761] RPC:       wake_up_next(ffff88007a346190 "xprt_sending")
[ 2679.056932] RPC:  1843 sync task going to sleep
[ 2679.057243] RPC:       xs_tcp_data_ready...
[ 2679.057412] RPC:       xs_tcp_data_recv started
[ 2679.057580] RPC:       reading TCP record fragment of length 24
[ 2679.057749] RPC:       reading XID (4 bytes)
[ 2679.057916] RPC:       reading request with XID 094bb2b3
[ 2679.058122] RPC:       reading CALL/REPLY flag (4 bytes)
[ 2679.058299] RPC:       read reply XID 094bb2b3
[ 2679.058467] RPC:       XID 094bb2b3 read 16 bytes
[ 2679.058635] RPC:       xprt = ffff88007a346000, tcp_copied = 24, tcp_offset = 24, tcp_reclen = 24
[ 2679.058966] RPC:  1843 xid 094bb2b3 complete (24 bytes received)
[ 2679.059166] RPC:  1843 __rpc_wake_up_task (now 4297346355)
[ 2679.059341] RPC:  1843 disabling timer
[ 2679.059507] RPC:  1843 removed from queue ffff88007a346320 "xprt_pending"
[ 2679.059684] RPC:       __rpc_wake_up_task done
[ 2679.059700] RPC:  1843 sync task resuming
[ 2679.059709] RPC:  1843 call_status (status 24)
[ 2679.059714] RPC:  1843 call_decode (status 24)
[ 2679.059722] RPC:  1843 validating NULL cred ffffffffa025da80
[ 2679.059729] RPC:  1843 using AUTH_NULL cred ffffffffa025da80 to unwrap rpc data
[ 2679.059734] RPC:  1843 call_decode result 0
[ 2679.059739] RPC:  1843 return 0, status 0
[ 2679.059742] RPC:  1843 release task
[ 2679.061339] RPC:       xs_tcp_data_recv done
[ 2679.061344] RPC:       freeing buffer of size 96 at ffff88007a343800
[ 2679.061353] RPC:  1843 release request ffff88007a2d6000
[ 2679.061358] RPC:       wake_up_next(ffff88007a3463e8 "xprt_backlog")
[ 2679.061364] RPC:       rpc_release_client(ffff880067dfde00)
[ 2679.061370] RPC:  1843 freeing task
[ 2679.061477] svc: initialising pool 0 for NFSv4 callback
[ 2679.061484] RPC:       unregistering [1073741824, 4, ''] with local rpcbind
[ 2679.061492] RPC:       new task initialized, procpid 6568
[ 2679.061496] RPC:       allocated task ffff88007a80e400
[ 2679.061502] RPC:  1844 __rpc_execute flags=0x680
[ 2679.061508] RPC:  1844 call_start rpcbind4 proc UNSET (sync)
[ 2679.061514] RPC:  1844 call_reserve (status 0)
[ 2679.061520] RPC:  1844 reserved req ffff88011a39e000 xid c856cbbf
[ 2679.061525] RPC:  1844 call_reserveresult (status 0)
[ 2679.061529] RPC:  1844 call_refresh (status 0)
[ 2679.061533] RPC:  1844 looking up UNIX cred
[ 2679.061536] RPC:       looking up UNIX cred
[ 2679.061543] RPC:  1844 refreshing UNIX cred ffff880078fb6300
[ 2679.061548] RPC:  1844 call_refreshresult (status 0)
[ 2679.061552] RPC:  1844 call_allocate (status 0)
[ 2679.061558] RPC:  1844 allocated buffer of size 488 at ffff88007aaa9000
[ 2679.061563] RPC:  1844 call_bind (status 0)
[ 2679.061568] RPC:  1844 call_connect xprt ffff88011a1e0000 is not connected
[ 2679.061574] RPC:  1844 xprt_connect xprt ffff88011a1e0000 is not connected
[ 2679.061580] RPC:  1844 sleep_on(queue "xprt_pending" time 4297346357)
[ 2679.061586] RPC:  1844 added to queue ffff88011a1e0320 "xprt_pending"
[ 2679.061590] RPC:  1844 setting alarm for 60000 ms
[ 2679.061596] RPC:       xs_connect scheduled xprt ffff88011a1e0000
[ 2679.061611] RPC:  1844 sync task going to sleep
[ 2679.061624] RPC:       disconnecting xprt ffff88011a1e0000 to reuse port
[ 2679.061636] RPC:       xs_error_report client ffff88011a1e0000...
[ 2679.061639] RPC:       error 0
[ 2679.061643] RPC:  1844 __rpc_wake_up_task (now 4297346357)
[ 2679.061646] RPC:  1844 disabling timer
[ 2679.061651] RPC:  1844 removed from queue ffff88011a1e0320 "xprt_pending"
[ 2679.061660] RPC:       __rpc_wake_up_task done
[ 2679.061666] RPC:       disconnected transport ffff88011a1e0000
[ 2679.061672] RPC:       worker connecting xprt ffff88011a1e0000 via tcp to 127.0.0.1 (port 111)
[ 2679.061810] RPC:       xs_tcp_state_change client ffff88011a1e0000...
[ 2679.061816] RPC:       state 1 conn 0 dead 0 zapped -1 sk_shutdown 0
[ 2679.061875] RPC:       ffff88011a1e0000 connect status 115 connected 1 sock state 1
[ 2679.062854] RPC:  1844 sync task resuming
[ 2679.062859] RPC:  1844 xprt_connect_status: retrying
[ 2679.062863] RPC:  1844 call_connect_status (status -11)
[ 2679.062868] RPC:  1844 call_transmit (status 0)
[ 2679.062872] RPC:  1844 xprt_prepare_transmit
[ 2679.062876] RPC:  1844 rpc_xdr_encode (status 0)
[ 2679.062881] RPC:  1844 marshaling UNIX cred ffff880078fb6300
[ 2679.062888] RPC:  1844 using AUTH_UNIX cred ffff880078fb6300 to wrap rpc data
[ 2679.062895] RPC:  1844 encoding RPCB_UNSET call (1073741824, 4, '', '')
[ 2679.062900] RPC:  1844 xprt_transmit(140)
[ 2679.063269] RPC:       xs_tcp_data_ready...
[ 2679.063274] RPC:       xs_tcp_data_recv started
[ 2679.063279] RPC:       reading TCP record fragment of length 28
[ 2679.063283] RPC:       reading XID (4 bytes)
[ 2679.063288] RPC:       reading request with XID c856cbbf
[ 2679.063292] RPC:       reading CALL/REPLY flag (4 bytes)
[ 2679.063296] RPC:       read reply XID c856cbbf
[ 2679.063302] RPC:       XID c856cbbf read 20 bytes
[ 2679.063307] RPC:       xprt = ffff88011a1e0000, tcp_copied = 28, tcp_offset = 28, tcp_reclen = 28
[ 2679.063313] RPC:  1844 xid c856cbbf complete (28 bytes received)
[ 2679.063319] RPC:       xs_tcp_data_recv done
[ 2679.063334] RPC:       xs_tcp_send_request(140) = 140
[ 2679.063338] RPC:  1844 xmit complete
[ 2679.063344] RPC:       wake_up_next(ffff88011a1e0258 "xprt_resend")
[ 2679.063349] RPC:       wake_up_next(ffff88011a1e0190 "xprt_sending")
[ 2679.063354] RPC:  1844 call_status (status 28)
[ 2679.063358] RPC:  1844 call_decode (status 28)
[ 2679.063363] RPC:  1844 validating UNIX cred ffff880078fb6300
[ 2679.063368] RPC:  1844 using AUTH_UNIX cred ffff880078fb6300 to unwrap rpc data
[ 2679.063373] RPC:  1844 RPCB_UNSET call succeeded
[ 2679.063377] RPC:  1844 call_decode result 0
[ 2679.063381] RPC:  1844 return 0, status 0
[ 2679.063384] RPC:  1844 release task
[ 2679.063390] RPC:       freeing buffer of size 488 at ffff88007aaa9000
[ 2679.063396] RPC:  1844 release request ffff88011a39e000
[ 2679.063400] RPC:       wake_up_next(ffff88011a1e03e8 "xprt_backlog")
[ 2679.063405] RPC:       rpc_release_client(ffff88011a88cc00)
[ 2679.063410] RPC:  1844 freeing task
[ 2679.063417] svc: __svc_unregister(NFSv4 callbackv4), error 0
[ 2679.063423] svc: creating transport tcp[0]
[ 2679.063431] svc: svc_create_socket(NFSv4 callback, 6, 0.0.0.0, port=0)
[ 2679.063468] svc: svc_setup_socket ffff880068ace940
[ 2679.063474] setting up TCP socket for listening
[ 2679.063479] svc: svc_setup_socket created ffff880060cd3c00 (inet ffff880060c95100)
[ 2679.063484] NFS: Callback listener port = 49824 (af 2)
[ 2679.063488] svc: creating transport tcp[0]
[ 2679.063494] svc: svc_create_socket(NFSv4 callback, 6, 0000:0000:0000:0000:0000:0000:0000:0000, port=0)
[ 2679.063530] svc: svc_setup_socket ffff880068acf440
[ 2679.063535] setting up TCP socket for listening
[ 2679.063539] svc: svc_setup_socket created ffff880060cd4000 (inet ffff88007a1132c0)
[ 2679.063544] NFS: Callback listener port = 56626 (af 10)
[ 2679.063680] svc: svc_destroy(NFSv4 callback, 2)
[ 2679.063686] --> nfs_get_client() = ffff8800685c3c00 [new]
[ 2679.063691] <-- nfs4_set_client() = 0 [new ffff8800685c3c00]
[ 2679.063750] <-- nfs4_init_server() = 0
[ 2679.063755] --> nfs4_get_rootfh()
[ 2679.063761] RPC:       creating UNIX authenticator for client ffff880060cb9c00
[ 2679.063770] RPC:       new task initialized, procpid 6568
[ 2679.063774] RPC:       allocated task ffff88007a80e400
[ 2679.063778] RPC:  1845 __rpc_execute flags=0x80
[ 2679.063783] RPC:  1845 call_start nfs4 proc LOOKUP_ROOT (sync)
[ 2679.063788] RPC:  1845 call_reserve (status 0)
[ 2679.063793] RPC:  1845 reserved req ffff88007a2d6000 xid 0a4bb2b3
[ 2679.063797] RPC:  1845 call_reserveresult (status 0)
[ 2679.063802] RPC:  1845 call_refresh (status 0)
[ 2679.063805] RPC:  1845 looking up UNIX cred
[ 2679.063809] RPC:       looking up UNIX cred
[ 2679.063814] RPC:  1845 refreshing UNIX cred ffff880078fb6300
[ 2679.063818] RPC:  1845 call_refreshresult (status 0)
[ 2679.063823] RPC:  1845 call_allocate (status 0)
[ 2679.063828] RPC:  1845 allocated buffer of size 1064 at ffff880078e61800
[ 2679.063832] RPC:  1845 call_bind (status 0)
[ 2679.063837] RPC:  1845 call_connect xprt ffff88007a346000 is connected
[ 2679.063841] RPC:  1845 call_transmit (status 0)
[ 2679.063845] RPC:  1845 xprt_prepare_transmit
[ 2679.063849] RPC:  1845 rpc_xdr_encode (status 0)
[ 2679.063854] RPC:  1845 marshaling UNIX cred ffff880078fb6300
[ 2679.063859] RPC:  1845 using AUTH_UNIX cred ffff880078fb6300 to wrap rpc data
[ 2679.063865] encode_compound: tag=
[ 2679.063870] RPC:  1845 xprt_transmit(152)
[ 2679.088332] svc: server ffff88007a48e000 waiting for data (to = 9223372036854775807)
[ 2679.088703] RPC:       xs_tcp_send_request(152) = 152
[ 2679.088880] RPC:  1845 xmit complete
[ 2679.089101] RPC:  1845 sleep_on(queue "xprt_pending" time 4297346385)
[ 2679.089293] RPC:  1845 added to queue ffff88007a346320 "xprt_pending"
[ 2679.089472] RPC:  1845 setting alarm for 60000 ms
[ 2679.089649] RPC:       wake_up_next(ffff88007a346258 "xprt_resend")
[ 2679.089820] RPC:       wake_up_next(ffff88007a346190 "xprt_sending")
[ 2679.089991] RPC:  1845 sync task going to sleep
[ 2679.090050] RPC:       xs_tcp_data_ready...
[ 2679.090055] RPC:       xs_tcp_data_recv started
[ 2679.090059] RPC:       reading TCP record fragment of length 44
[ 2679.090063] RPC:       reading XID (4 bytes)
[ 2679.090067] RPC:       reading reply for XID 0a4bb2b3
[ 2679.090071] RPC:       reading CALL/REPLY flag (4 bytes)
[ 2679.090075] RPC:       read reply XID 0a4bb2b3
[ 2679.090080] RPC:       XID 0a4bb2b3 read 36 bytes
[ 2679.090085] RPC:       xprt = ffff88007a346000, tcp_copied = 44, tcp_offset = 44, tcp_reclen = 44
[ 2679.090091] RPC:  1845 xid 0a4bb2b3 complete (44 bytes received)
[ 2679.090098] RPC:  1845 __rpc_wake_up_task (now 4297346386)
[ 2679.090102] RPC:  1845 disabling timer
[ 2679.090107] RPC:  1845 removed from queue ffff88007a346320 "xprt_pending"
[ 2679.090111] RPC:       __rpc_wake_up_task done
[ 2679.090114] RPC:       xs_tcp_data_recv done
[ 2679.092850] RPC:  1845 sync task resuming
[ 2679.093042] RPC:  1845 call_status (status 44)
[ 2679.093222] RPC:  1845 call_decode (status 44)
[ 2679.093389] RPC:  1845 validating UNIX cred ffff880078fb6300
[ 2679.093561] RPC:  1845 using AUTH_UNIX cred ffff880078fb6300 to unwrap rpc data
[ 2679.093890] RPC:  1845 call_decode result -1
[ 2679.094093] RPC:  1845 return 0, status -1
[ 2679.094266] RPC:  1845 release task
[ 2679.094437] RPC:       freeing buffer of size 1064 at ffff880078e61800
[ 2679.094608] RPC:  1845 release request ffff88007a2d6000
[ 2679.094776] RPC:       wake_up_next(ffff88007a3463e8 "xprt_backlog")
[ 2679.094945] RPC:       rpc_release_client(ffff880060cb9c00)
[ 2679.095151] RPC:  1845 freeing task
[ 2679.095329] RPC:       new task initialized, procpid 6568
[ 2679.095499] RPC:       allocated task ffff88007a80e400
[ 2679.095669] RPC:  1846 __rpc_execute flags=0x80
[ 2679.095837] RPC:  1846 call_start nfs4 proc LOOKUP_ROOT (sync)
[ 2679.096041] RPC:  1846 call_reserve (status 0)
[ 2679.096215] RPC:  1846 reserved req ffff88007a2d6000 xid 0b4bb2b3
[ 2679.096386] RPC:  1846 call_reserveresult (status 0)
[ 2679.096554] RPC:  1846 call_refresh (status 0)
[ 2679.096722] RPC:  1846 looking up NULL cred
[ 2679.096888] RPC:       looking up NULL cred
[ 2679.097091] RPC:  1846 refreshing NULL cred ffffffffa025da80
[ 2679.097268] RPC:  1846 call_refreshresult (status 0)
[ 2679.097438] RPC:  1846 call_allocate (status 0)
[ 2679.097606] RPC:  1846 allocated buffer of size 764 at ffff880078e61800
[ 2679.097779] RPC:  1846 call_bind (status 0)
[ 2679.097945] RPC:  1846 call_connect xprt ffff88007a346000 is connected
[ 2679.098152] RPC:  1846 call_transmit (status 0)
[ 2679.098325] RPC:  1846 xprt_prepare_transmit
[ 2679.098494] RPC:  1846 rpc_xdr_encode (status 0)
[ 2679.098661] RPC:  1846 marshaling NULL cred ffffffffa025da80
[ 2679.098832] RPC:  1846 using AUTH_NULL cred ffffffffa025da80 to wrap rpc data
[ 2679.099032] encode_compound: tag=
[ 2679.099202] RPC:  1846 xprt_transmit(80)
[ 2679.099396] RPC:       xs_tcp_send_request(80) = 80
[ 2679.099564] RPC:  1846 xmit complete
[ 2679.099730] RPC:  1846 sleep_on(queue "xprt_pending" time 4297346395)
[ 2679.099902] RPC:  1846 added to queue ffff88007a346320 "xprt_pending"
[ 2679.100111] RPC:  1846 setting alarm for 60000 ms
[ 2679.100293] RPC:       wake_up_next(ffff88007a346258 "xprt_resend")
[ 2679.100466] RPC:       wake_up_next(ffff88007a346190 "xprt_sending")
[ 2679.100636] RPC:  1846 sync task going to sleep
[ 2679.101060] RPC:       xs_tcp_data_ready...
[ 2679.101235] RPC:       xs_tcp_data_recv started
[ 2679.101403] RPC:       reading TCP record fragment of length 44
[ 2679.101573] RPC:       reading XID (4 bytes)
[ 2679.101740] RPC:       reading reply for XID 0b4bb2b3
[ 2679.101908] RPC:       reading CALL/REPLY flag (4 bytes)
[ 2679.102031] RPC:       read reply XID 0b4bb2b3
[ 2679.102031] RPC:       XID 0b4bb2b3 read 36 bytes
[ 2679.102031] RPC:       xprt = ffff88007a346000, tcp_copied = 44, tcp_offset = 44, tcp_reclen = 44
[ 2679.102031] RPC:  1846 xid 0b4bb2b3 complete (44 bytes received)
[ 2679.102031] RPC:  1846 __rpc_wake_up_task (now 4297346398)
[ 2679.102031] RPC:  1846 disabling timer
[ 2679.102031] RPC:  1846 removed from queue ffff88007a346320 "xprt_pending"
[ 2679.102031] RPC:       __rpc_wake_up_task done
[ 2679.103470] RPC:  1846 sync task resuming
[ 2679.103475] RPC:  1846 call_status (status 44)
[ 2679.103479] RPC:  1846 call_decode (status 44)
[ 2679.103484] RPC:  1846 validating NULL cred ffffffffa025da80
[ 2679.103489] RPC:  1846 using AUTH_NULL cred ffffffffa025da80 to unwrap rpc data
[ 2679.103494] RPC:  1846 call_decode result -1
[ 2679.103498] RPC:  1846 return 0, status -1
[ 2679.103501] RPC:  1846 release task
[ 2679.102031] RPC:       xs_tcp_data_recv done
[ 2679.105115] RPC:       freeing buffer of size 764 at ffff880078e61800
[ 2679.105121] RPC:  1846 release request ffff88007a2d6000
[ 2679.105126] RPC:       wake_up_next(ffff88007a3463e8 "xprt_backlog")
[ 2679.105131] RPC:       rpc_release_client(ffff880060cb9c00)
[ 2679.105135] RPC:  1846 freeing task
[ 2679.105140] nfs4_get_rootfh: getroot error = 11
[ 2679.105144] <-- nfs4_get_rootfh() = -11
[ 2679.105147] --> nfs_free_server()
[ 2679.116035] RPC:       shutting down nfs client for build-toolchain
[ 2679.116209] RPC:       rpc_release_client(ffff880060cb9c00)
[ 2679.116378] RPC:       destroying nfs client for build-toolchain
[ 2679.116588] RPC:       rpc_release_client(ffff880067dfde00)
[ 2679.116762] --> nfs_put_client({1})
[ 2679.116929] --> nfs_free_client(4)
[ 2679.117134] svc: server ffff88007a48e000, no data yet
[ 2679.117359] svc: svc_destroy(NFSv4 callback, 1)
[ 2679.117529] svc: svc_delete_xprt(ffff880060cd4000)
[ 2679.117696] svc: svc_tcp_sock_detach(ffff880060cd4000)
[ 2679.117865] svc: svc_sock_detach(ffff880060cd4000)
[ 2679.118074] svc: svc_sock_free(ffff880060cd4000)
[ 2679.118266] svc: svc_delete_xprt(ffff880060cd3c00)
[ 2679.118433] svc: svc_tcp_sock_detach(ffff880060cd3c00)
[ 2679.118602] svc: svc_sock_detach(ffff880060cd3c00)
[ 2679.118771] svc: svc_sock_free(ffff880060cd3c00)
[ 2679.118946] RPC:       unregistering [1073741824, 4, ''] with local rpcbind
[ 2679.119157] RPC:       new task initialized, procpid 6568
[ 2679.119333] RPC:       allocated task ffff88007a80e400
[ 2679.119504] RPC:  1847 __rpc_execute flags=0x680
[ 2679.119672] RPC:  1847 call_start rpcbind4 proc UNSET (sync)
[ 2679.119842] RPC:  1847 call_reserve (status 0)
[ 2679.120039] RPC:  1847 reserved req ffff88011a39e000 xid c956cbbf
[ 2679.120217] RPC:  1847 call_reserveresult (status 0)
[ 2679.120387] RPC:  1847 call_refresh (status 0)
[ 2679.120554] RPC:  1847 looking up UNIX cred
[ 2679.120720] RPC:       looking up UNIX cred
[ 2679.120888] RPC:  1847 refreshing UNIX cred ffff880078fb6300
[ 2679.121093] RPC:  1847 call_refreshresult (status 0)
[ 2679.121269] RPC:  1847 call_allocate (status 0)
[ 2679.121439] RPC:  1847 allocated buffer of size 488 at ffff880078e66800
[ 2679.121611] RPC:  1847 call_bind (status 0)
[ 2679.121778] RPC:  1847 call_connect xprt ffff88011a1e0000 is connected
[ 2679.121950] RPC:  1847 call_transmit (status 0)
[ 2679.122153] RPC:  1847 xprt_prepare_transmit
[ 2679.122327] RPC:  1847 rpc_xdr_encode (status 0)
[ 2679.122498] RPC:  1847 marshaling UNIX cred ffff880078fb6300
[ 2679.122669] RPC:  1847 using AUTH_UNIX cred ffff880078fb6300 to wrap rpc data
[ 2679.122843] RPC:  1847 encoding RPCB_UNSET call (1073741824, 4, '', '')
[ 2679.123040] RPC:  1847 xprt_transmit(140)
[ 2679.123253] RPC:       xs_tcp_send_request(140) = 140
[ 2679.123425] RPC:  1847 xmit complete
[ 2679.123594] RPC:       xs_tcp_data_ready...
[ 2679.123599] RPC:       xs_tcp_data_recv started
[ 2679.123604] RPC:       reading TCP record fragment of length 28
[ 2679.123608] RPC:       reading XID (4 bytes)
[ 2679.123613] RPC:       reading reply for XID c956cbbf
[ 2679.123617] RPC:       reading CALL/REPLY flag (4 bytes)
[ 2679.123621] RPC:       read reply XID c956cbbf
[ 2679.123626] RPC:       XID c956cbbf read 20 bytes
[ 2679.123631] RPC:       xprt = ffff88011a1e0000, tcp_copied = 28, tcp_offset = 28, tcp_reclen = 28
[ 2679.123637] RPC:  1847 xid c956cbbf complete (28 bytes received)
[ 2679.123644] RPC:       xs_tcp_data_recv done
[ 2679.125634] RPC:       wake_up_next(ffff88011a1e0258 "xprt_resend")
[ 2679.125817] RPC:       wake_up_next(ffff88011a1e0190 "xprt_sending")
[ 2679.125990] RPC:  1847 call_status (status 28)
[ 2679.126193] RPC:  1847 call_decode (status 28)
[ 2679.131579] RPC:  1847 validating UNIX cred ffff880078fb6300
[ 2679.131750] RPC:  1847 using AUTH_UNIX cred ffff880078fb6300 to unwrap rpc data
[ 2679.132108] RPC:  1847 RPCB_UNSET call succeeded
[ 2679.132281] RPC:  1847 call_decode result 0
[ 2679.132448] RPC:  1847 return 0, status 0
[ 2679.132613] RPC:  1847 release task
[ 2679.132780] RPC:       freeing buffer of size 488 at ffff880078e66800
[ 2679.132951] RPC:  1847 release request ffff88011a39e000
[ 2679.133151] RPC:       wake_up_next(ffff88011a1e03e8 "xprt_backlog")
[ 2679.133329] RPC:       rpc_release_client(ffff88011a88cc00)
[ 2679.133501] RPC:  1847 freeing task
[ 2679.133667] svc: __svc_unregister(NFSv4 callbackv4), error 0
[ 2679.133853] NFS: releasing client cookie (0xffff8800685c3c00/0xffff88007a2c2e10)
[ 2679.134228] RPC:       shutting down nfs client for build-toolchain
[ 2679.134405] RPC:       rpc_release_client(ffff880067dfde00)
[ 2679.134574] RPC:       destroying nfs client for build-toolchain
[ 2679.134771] RPC:       destroying transport ffff88007a346000
[ 2679.134948] RPC:       xs_destroy xprt ffff88007a346000
[ 2679.135156] RPC:       xs_close xprt ffff88007a346000
[ 2679.135358] RPC:       disconnected transport ffff88007a346000
[ 2679.135535] <-- nfs_free_client()
[ 2679.135716] <-- nfs_free_server()
[ 2679.135880] <-- nfs4_create_server() = error -11
[ 2679.136096] <-- nfs4_try_mount() = -11 [error]

Thanks.

-- 
Dmitry
